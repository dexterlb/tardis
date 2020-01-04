package stupidproto

import (
	"fmt"
	"math/rand"
	"strings"
	"testing"

	fuzz "github.com/google/gofuzz"
)

func TestEncodeDecode_single(t *testing.T) {
	twoWay(t, [][]byte{[]byte("foo")})
}

func TestEncodeDecode_none(t *testing.T) {
	twoWay(t, [][]byte{})
}

func TestEncodeDecode_empty(t *testing.T) {
	twoWay(t, [][]byte{[]byte{}})
}

func TestEncodeDecode_simple(t *testing.T) {
	twoWay(t, [][]byte{[]byte("foo"), []byte("bar")})
}

func TestEncodeDecode_empties(t *testing.T) {
	twoWay(t, [][]byte{[]byte("foo"), []byte{}, []byte("bar"), []byte{}})
}

func TestEncodeDecode_zero(t *testing.T) {
	twoWay(t, [][]byte{[]byte("fo\000o"), []byte("bar\000")})
}

func TestEncodeDecode_edge(t *testing.T) {
	twoWay(t, [][]byte{[]byte("12345678"), []byte("87654321")})
	twoWay(t, [][]byte{[]byte("1234567"), []byte("7654321")})
}

func TestEncodeDecode_edge8(t *testing.T) {
	twoWay(t, [][]byte{[]byte("12345678")})
}

func TestEncodeDecode_edge6(t *testing.T) {
	twoWay(t, [][]byte{[]byte("123456")})
}

func TestEncodeDecode_long_msg(t *testing.T) {
	twoWay(t, [][]byte{[]byte("abcdefghijklmnopqrstuvwxyz")})
}

func TestEncodeDecode_longer_msg(t *testing.T) {
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
	for i := 0; i < 100; i++ {
		var msgs [][]byte
		f := fuzz.New().NumElements(0, 200)
		f.Fuzz(&msgs)
		twoWay(t, msgs)
	}
}

func TestCorrupt_single_within_data(t *testing.T) {
	msgs := [][]byte{[]byte("foo")}
	expected := [][]byte{[]byte{}}
	corruptTest(t, msgs, expected, func(b []byte) {
		corruptWithinDataToData(b, 0)
	})
}

func TestCorrupt_single_within_end(t *testing.T) {
	msgs := [][]byte{[]byte("foo")}
	expected := [][]byte{[]byte{}, []byte{}}
	corruptTest(t, msgs, expected, func(b []byte) {
		corruptWithinDataToEnd(b, 0)
	})
}

func TestCorrupt_fuzz_within_data(t *testing.T) {
	for i := 0; i < 50; i++ {
		var msgs [][]byte
		f := fuzz.New().NumElements(1, 5)
		f.Fuzz(&msgs)

		if len(msgs) == 0 {
			continue
		}

		idx := rand.Intn(len(msgs))
		if len(msgs[idx]) == 0 {
			continue
		}

		expected := copyMsgs(msgs)
		expected[idx] = nil

		corruptTest(t, msgs, expected, func(b []byte) {
			corruptWithinDataToData(b, idx)
		})
	}
}

func TestCorrupt_fuzz_within_end(t *testing.T) {
	for i := 0; i < 50; i++ {
		var msgs [][]byte
		f := fuzz.New().NumElements(1, 100)
		f.Fuzz(&msgs)

		if len(msgs) == 0 {
			continue
		}

		idx := rand.Intn(len(msgs))
		if len(msgs[idx]) == 0 {
			continue
		}

		expected := copyMsgs(msgs)
		expected[idx] = nil
		expected = append(expected[:idx], append([][]byte{nil}, expected[idx:]...)...)

		corruptTest(t, msgs, expected, func(b []byte) {
			corruptWithinDataToEnd(b, idx)
		})
	}
}

func TestCorrupt_fuzz_endbit(t *testing.T) {
	for i := 0; i < 50; i++ {
		var msgs [][]byte
		f := fuzz.New().NumElements(1, 5)
		f.Fuzz(&msgs)

		if len(msgs) < 3 {
			continue
		}
		idx := rand.Intn(len(msgs) - 1)
		expected := copyMsgs(msgs)
		expected[idx] = nil
		expected = append(expected[:idx+1], expected[idx+2:]...)

		corruptTest(t, msgs, expected, func(b []byte) {
			corruptEndBit(b, idx)
		})
	}
}

func corruptEndBit(data []byte, msgNo int) {
	_, end := bounds(data, msgNo)
	data[end] &= (^byte(1))
}

func corruptWithinDataToData(data []byte, msgNo int) {
	start, end := bounds(data, msgNo)
	n := start + rand.Intn(end-start-1)
	old := data[n]
	data[n] += byte(rand.Intn(127) * 2 + 2)
	if data[n] == old {
		panic("could not corrupt")
	}
}

func corruptWithinDataToEnd(data []byte, msgNo int) {
	start, end := bounds(data, msgNo)
	n := start + rand.Intn(end-start-1)
	old := data[n]
	data[n] += byte(rand.Intn(126)*2 + 1)
	if data[n] == old {
		panic("could not corrupt")
	}
}

func bounds(data []byte, msgNo int) (int, int) {
	var i int
	var end int
	var start int
	end = -1
	for j := 0; j <= msgNo; i++ {
		if data[i]%2 == 1 {
			if end >= 0 {
				start = end + 1
			}
			end = i
			j++
		}
	}

	return start, end
}

func corruptTest(t *testing.T, msgs [][]byte, expected [][]byte, corrupter func([]byte)) {
	encoded := EncodeMessages(msgs)
	corrupted := copyBytes(encoded)
	corrupter(corrupted)
	result := DecodeMessages(corrupted)

	if !compare(expected, result) {
		t.Fatalf("decoded corrupted data differs from expected:\nbefore: %s\nencoded: %s\ncorrupted: %s\nafter: %s\nexpected: %s\n",
			showMsgs(msgs),
			showBytes(encoded),
			showBytes(corrupted),
			showMsgs(result),
			showMsgs(expected),
		)
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

	if !compare(msgs, result) {
		t.Fatalf("decoded data differs from original:\nbefore: %s\nencoded: %s\nafter: %s\n",
			showMsgs(msgs),
			showBytes(encoded),
			showMsgs(result),
		)
	}
}

func compare(a [][]byte, b [][]byte) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if !compareBytes(a[i], b[i]) {
			return false
		}
	}
	return true
}

func compareBytes(a []byte, b []byte) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
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

func copyBytes(xs []byte) []byte {
	rs := make([]byte, len(xs))
	for i, x := range xs {
		rs[i] = x
	}

	return rs
}

func copyMsgs(msgs [][]byte) [][]byte {
	rs := make([][]byte, len(msgs))
	for i, msg := range msgs {
		rs[i] = copyBytes(msg)
	}

	return rs
}
