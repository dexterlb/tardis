### stupid_proto

#### Problem
Suppose we want to transmit small messages over a dumb wire protocol (think UART)
between devices (think very small microcontrollers).

We want the following properties:

- Easily determine where one message ends and another begins
- Be efficient in terms of message size
- Be efficient in terms of performance (usually a lesser bottleneck than message size, though)
- Corruption of a message does not potentially invalidate other messages

#### Known methods for splitting messages
##### Start + length
At the start of the message, specify its length. Optionally, have a "start byte"
and/or a "message type" (for example, [TLV encoding](https://en.wikipedia.org/wiki/Type-length-value)). Also, optionally include a CRC or a checksum at the end.

Pros:
- very easy to implement
- efficient in terms of both message size and performance

Cons:
- message corruptions are difficult to process, and even then may cause
significant problems: for example, if the "length" field gets substituted
a large number `N`, a naïve receiver may drop multiple messages which follow
the corrupted one. A more clever receiver might try to validate a checksum
at the end of the `N` bytes, but this has two problems:
    - it induces latency, since we need to buffer all `N` bytes, perform a check
    and backtrack to the next possible message start
    - if we don't do backtracking, connection drops in the middle of a message
    and message corruptions might cause us to discard extra messages
    - even if we do this, the payload of the corrupted message might contain a
    valid message, which the receiver would handle, although it should not
    - in the unlikely event that the payload of the corrupted message contains a
    valid "begin message" sequence and `N` spans into a byte which happens to be
    the exact checksum for those `N` bytes several messages ahead, total mayhem
    ensues

##### Just use text
Encode the message in a text format - comma-separated numbers, json, base64, etc.
End messages with newlines. Optionally include an integrity check as part of the message.

Pros:
- easy to debug
- it is clear where a message ends. If a byte within a message gets corrupted,
it only affects said message. If the newline character gets corrupted, it
invalidates 2 messages, since it also acts as a "start" for the next message.
No need to backtrack to overbuffer and backtrack.

Cons:
- inefficient

#### Proposed method
Note: for simplicity, we will use byte-sized words. This can naturally be
applied for arbitrary words as well.

Use a least significant bit in every byte to denote whether the message ends
or continues. Payload bytes have a LSB set to zero, while the "end" byte has
the LSB set to one. Split the whole message into 7-bit chunks (padding the last
chunk with zeroes when needed). Then transmit these chunks together with a zero
LSB, and at the end transmit a "1". As a bonus, use the remaining 7 bits of
the "end" byte for a checksum.

Pros:
- has the corruption handling properties of "Just use text"
- quite size-efficient (asymptotically 8/7 of the original message size)
- probably more performant than using text

Cons:
- difficult to implement, has multiple edge cases
