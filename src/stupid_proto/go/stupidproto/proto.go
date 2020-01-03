package stupidproto

// #cgo CFLAGS: -g -Wall -Wno-unused-variable
/*
#include "proto.h"
*/
import "C"

type EncodeChunk struct {
	Data byte
	End  bool
}

type DecodeChunk struct {
	Data byte
	End  bool
	Err  bool
}

func ByteEncoder(in <-chan EncodeChunk, out chan<- byte) {
	defer close(out)

	var enc C.struct_proto_encoder_state
	var sync C.struct_proto_sync_output
	var b C.uchar

	C.proto_encoder_init_sync(&enc, &sync)
	for c := range in {
		if c.End {
			C.proto_encoder_end_sync(&enc)
		} else {
			C.proto_encoder_push_sync(&enc, C.uchar(c.Data))
		}

		for C.proto_sync_pop(&sync, &b) {
			out <- byte(b)
		}
	}
}

func ByteDecoder(in <-chan byte, out chan<- DecodeChunk) {
	defer close(out)
	var dec C.struct_proto_decoder_state
	var sync C.struct_proto_sync_output

	C.proto_decoder_init_sync(&dec, &sync)
	for b := range in {
		C.proto_decoder_push_sync(&dec, C.uchar(b))

		var cb C.uchar
		for C.proto_sync_pop(&sync, &cb) {
			out <- DecodeChunk{
				Data: byte(cb),
			}
		}

		if C.proto_sync_err(&sync) {
			out <- DecodeChunk{
				Err: true,
				End: true,
			}
		} else if C.proto_sync_end(&sync) {
			out <- DecodeChunk{
				End: true,
			}
		}
	}
}

func MsgEncoder(in <-chan []byte, out chan<- byte) {
	chunks := make(chan EncodeChunk)
	defer close(chunks)
	go ByteEncoder(chunks, out)

	for msg := range in {
		for _, b := range msg {
			chunks <- EncodeChunk{Data: b}
		}
		chunks <- EncodeChunk{End: true}
	}
}

func MsgDecoder(in <-chan byte, out chan<- []byte) {
	var msg []byte
	defer close(out)
	chunks := make(chan DecodeChunk)

	go ByteDecoder(in, chunks)

	for chunk := range chunks {
		if chunk.End {
			if chunk.Err {
				out <- nil
			} else {
				out <- msg
			}
			msg = nil
		} else {
			msg = append(msg, chunk.Data)
		}
	}
}

func EncodeMessages(in [][]byte) []byte {
	inc := make(chan []byte)
	outc := make(chan byte)
	go MsgEncoder(inc, outc)

	go func() {
		defer close(inc)
		for _, msg := range in {
			inc <- msg
		}
	}()

	var out []byte
	for b := range outc {
		out = append(out, b)
	}

	return out
}

func DecodeMessages(in []byte) [][]byte {
	inc := make(chan byte)
	outc := make(chan []byte)
	go MsgDecoder(inc, outc)

	go func() {
		defer close(inc)
		for _, b := range in {
			inc <- b
		}
	}()

	var out [][]byte
	for msg := range outc {
		out = append(out, msg)
	}

	return out
}
