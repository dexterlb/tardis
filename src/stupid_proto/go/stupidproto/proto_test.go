package stupidproto

import (
	"fmt"
	"reflect"
	"strings"
	"testing"

	fuzz "github.com/google/gofuzz"
)

func TestEncodeDecode_single(t *testing.T) {
	twoWay(t, [][]byte{[]byte("foo")})
}

func TestEncodeDecode_simple(t *testing.T) {
	twoWay(t, [][]byte{[]byte("foo"), []byte("bar")})
}

func TestEncodeDecode_zero(t *testing.T) {
	twoWay(t, [][]byte{[]byte("fo\000o"), []byte("bar\000")})
}

func TestEncodeDecode_edge(t *testing.T) {
	twoWay(t, [][]byte{[]byte("12345678"), []byte("87654321")})
	twoWay(t, [][]byte{[]byte("1234567"), []byte("7654321")})
}

func TestEncodeDecode_edge6(t *testing.T) {
	twoWay(t, [][]byte{[]byte("123456")})
}

func TestEncodeDecode_long(t *testing.T) {
	twoWay(t, [][]byte{[]byte("abcdefghijklmnopqrstuvwxyz")})
}

func TestEncodeDecode_longer(t *testing.T) {
	twoWay(t, [][]byte{
		[]byte("buffalo buffalo buffalo buffalo buffalo buffalo buffalo"),
		[]byte("the quick brown fox jumps over the lazy dog"),
	})
}

func TestEncodeDecode_fuzz_short(t *testing.T) {
	for i := 0; i < 100; i++ {
		var msgs [][]byte
		f := fuzz.New()
		f.Fuzz(&msgs)
		twoWay(t, msgs)
	}
}

func TestEncodeDecode_fuzz_long(t *testing.T) {
	for i := 0; i < 500; i++ {
		var msgs [][]byte
		f := fuzz.New().NumElements(0, 200)
		f.Fuzz(&msgs)
		twoWay(t, msgs)
	}
}

func twoWay(t *testing.T, msgs [][]byte) {
	encoded := EncodeMessages(msgs)
	result := DecodeMessages(encoded)

	if len(encoded) != expectLen(msgs) {
		t.Fatalf("encoded data has wrong length (%d != %d):\nbefore: %s\nencoded: %s\nafter: %s\n",
			len(encoded), expectLen(msgs),
			showMsgs(msgs),
			showBytes(encoded),
			showMsgs(result),
		)
	}

	if !reflect.DeepEqual(msgs, result) {
		t.Fatalf("decoded data differs from original:\nbefore: %s\nencoded: %s\nafter: %s\n",
			showMsgs(msgs),
			showBytes(encoded),
			showMsgs(result),
		)
	}
}

func expectLen(msgs [][]byte) int {
	result := 0

	for _, msg := range msgs {
		result += ((len(msg)*8 + 6) / 7) + 1
	}

	return result
}

func showBytes(xs []byte) string {
	strs := make([]string, len(xs))
	for i, x := range xs {
		strs[i] = fmt.Sprintf("%02x", int(x))
	}
	return fmt.Sprintf("[%s]", strings.Join(strs, " "))
}

func showMsgs(msgs [][]byte) string {
	strs := make([]string, len(msgs))
	for i, msg := range msgs {
		strs[i] = showBytes(msg)
	}
	return fmt.Sprintf("{%s}", strings.Join(strs, " "))
}
