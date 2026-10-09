import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_event_stream.dart';

void main() {
  List<int> u32(int value) => [
    (value >> 24) & 0xff,
    (value >> 16) & 0xff,
    (value >> 8) & 0xff,
    value & 0xff,
  ];

  /// Builds one AWS event-stream frame. Both CRCs are zero — the decoder does
  /// not verify them, which this also pins down.
  Uint8List frame(Map<String, String> headers, String payload) {
    final headerBytes = BytesBuilder();
    headers.forEach((name, value) {
      final valueBytes = utf8.encode(value);
      headerBytes
        ..addByte(name.length)
        ..add(utf8.encode(name))
        ..addByte(7) // string
        ..add([(valueBytes.length >> 8) & 0xff, valueBytes.length & 0xff])
        ..add(valueBytes);
    });

    final header = headerBytes.toBytes();
    final body = utf8.encode(payload);
    final total = 12 + header.length + body.length + 4;

    return (BytesBuilder()
          ..add(u32(total))
          ..add(u32(header.length))
          ..add(u32(0))
          ..add(header)
          ..add(body)
          ..add(u32(0)))
        .toBytes();
  }

  /// Wraps a Messages API stream event the way Bedrock does.
  Uint8List eventFrame(Map<String, dynamic> event) => frame(
    const {
      ':event-type': 'chunk',
      ':content-type': 'application/json',
      ':message-type': 'event',
    },
    jsonEncode({
      'bytes': base64.encode(utf8.encode(jsonEncode(event))),
      'p': 'padding-the-frame',
    }),
  );

  Future<String> decode(Stream<List<int>> source) async {
    final chunks = await awsEventStreamToSse(source).toList();
    return utf8.decode(chunks.expand((c) => c).toList());
  }

  test('re-frames events as SSE named by the payload type', () async {
    final sse = await decode(
      Stream.value([
        ...eventFrame({'type': 'content_block_delta', 'index': 0}),
      ]),
    );

    // The event name must come from the payload, not from `:event-type`,
    // which Bedrock always sets to the literal "chunk".
    expect(sse, 'event: content_block_delta\ndata: {"type":"content_block_delta","index":0}\n\n');
  });

  test('decodes a full message in order', () async {
    final bytes = [
      ...eventFrame({'type': 'message_start'}),
      ...eventFrame({'type': 'content_block_delta', 'index': 0}),
      ...eventFrame({'type': 'message_stop'}),
    ];

    final sse = await decode(Stream.value(bytes));

    expect(
      RegExp(r'event: (\w+)').allMatches(sse).map((m) => m.group(1)).toList(),
      ['message_start', 'content_block_delta', 'message_stop'],
    );
  });

  test('reassembles frames split across chunk boundaries', () async {
    final bytes = [
      ...eventFrame({'type': 'message_start'}),
      ...eventFrame({'type': 'message_stop'}),
    ];

    // One byte per chunk is the worst case the socket can hand us.
    final sse = await decode(Stream.fromIterable(bytes.map((b) => [b])));

    expect(
      RegExp(r'event: (\w+)').allMatches(sse).map((m) => m.group(1)).toList(),
      ['message_start', 'message_stop'],
    );
  });

  test('emits nothing until a frame is complete', () async {
    final bytes = eventFrame({'type': 'message_start'});

    final sse = await decode(Stream.value(bytes.sublist(0, bytes.length - 1)));

    expect(sse, isEmpty);
  });

  test('surfaces mid-stream exception frames as error events', () async {
    final sse = await decode(
      Stream.value(
        frame(
          const {':message-type': 'exception', ':exception-type': 'throttlingException'},
          jsonEncode({'message': 'Too many requests'}),
        ),
      ),
    );

    expect(sse, startsWith('event: error\n'));
    expect(sse, contains('Too many requests'));
  });

  test('rejects a frame claiming an impossible length', () async {
    await expectLater(
      decode(Stream.value([...u32(3), ...u32(0), ...u32(0)])),
      throwsA(isA<FormatException>()),
    );
  });
}
