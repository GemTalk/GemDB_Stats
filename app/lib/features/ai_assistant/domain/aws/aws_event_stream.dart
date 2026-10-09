import 'dart:convert';
import 'dart:typed_data';

/// Re-frames Bedrock's `invoke-with-response-stream` response as Anthropic SSE.
///
/// Bedrock wraps the ordinary Messages API stream events in AWS's binary
/// event-stream encoding. Each frame looks like:
///
/// ```text
/// [4B total length][4B headers length][4B prelude CRC]
/// [headers][payload][4B message CRC]
/// ```
///
/// where every header is `[1B name length][name][1B value type][2B value
/// length][value]`, and the payload is a JSON object with a base64 `bytes`
/// field (plus a `p` padding field). Decoding `bytes` yields the SSE `data:`
/// JSON the Anthropic SDK already knows how to parse.
///
/// Converting back to SSE here means the SDK's own parser, event models, and
/// stream accumulator keep working untouched.
///
/// The two CRCs are not verified: the payload already arrives over TLS, and a
/// corrupt frame surfaces immediately as a JSON decode error anyway.
Stream<List<int>> awsEventStreamToSse(Stream<List<int>> source) async* {
  /// Frames are small (a few hundred bytes); a copy-on-consume buffer keeps
  /// this simple and is not worth optimising.
  var buffer = Uint8List(0);

  await for (final chunk in source) {
    buffer = Uint8List.fromList([...buffer, ...chunk]);

    while (buffer.length >= _preludeBytes) {
      final view = ByteData.sublistView(buffer);
      final totalLength = view.getUint32(0);

      // A frame must at least hold its own prelude and trailing CRC.
      if (totalLength < _preludeBytes + 4) {
        throw FormatException('Invalid AWS event-stream frame length: $totalLength');
      }
      if (buffer.length < totalLength) {
        break; // Wait for the rest of the frame.
      }

      final headersLength = view.getUint32(4);
      final headers = _parseHeaders(
        Uint8List.sublistView(buffer, _preludeBytes, _preludeBytes + headersLength),
      );
      final payload = Uint8List.sublistView(
        buffer,
        _preludeBytes + headersLength,
        totalLength - 4,
      );

      final sse = _frameToSse(headers, payload);
      if (sse != null) {
        yield utf8.encode(sse);
      }

      buffer = buffer.sublist(totalLength);
    }
  }
}

/// Bytes before the headers: total length, headers length, prelude CRC.
const _preludeBytes = 12;

/// Header value type for a UTF-8 string — the only type Bedrock emits here.
const _stringHeaderType = 7;

Map<String, String> _parseHeaders(Uint8List bytes) {
  final headers = <String, String>{};
  var offset = 0;

  while (offset < bytes.length) {
    final nameLength = bytes[offset];
    offset += 1;
    final name = utf8.decode(bytes.sublist(offset, offset + nameLength));
    offset += nameLength;

    final valueType = bytes[offset];
    offset += 1;
    if (valueType != _stringHeaderType) {
      // Bedrock only sends string headers. Anything else means this frame is
      // shaped differently than expected, so stop rather than mis-read it.
      break;
    }

    final valueLength = ByteData.sublistView(bytes, offset, offset + 2).getUint16(0);
    offset += 2;
    headers[name] = utf8.decode(bytes.sublist(offset, offset + valueLength));
    offset += valueLength;
  }

  return headers;
}

/// Renders one frame as an SSE event, or null if it carries nothing useful.
String? _frameToSse(Map<String, String> headers, Uint8List payload) {
  final decoded = _decodePayload(payload);
  if (decoded == null) {
    return null;
  }

  // `:message-type` is `event` for stream events and `exception` for
  // mid-stream failures (throttling, model errors). Note that `:event-type` is
  // always the literal `chunk`, so the real event name comes from the payload.
  if (headers[':message-type'] != 'event') {
    return 'event: error\ndata: ${jsonEncode({'type': 'error', 'error': decoded})}\n\n';
  }

  final type = decoded['type'];
  if (type is! String) {
    return null;
  }
  return 'event: $type\ndata: ${jsonEncode(decoded)}\n\n';
}

Map<String, dynamic>? _decodePayload(Uint8List payload) {
  if (payload.isEmpty) {
    return null;
  }
  final outer = jsonDecode(utf8.decode(payload));
  if (outer is! Map<String, dynamic>) {
    return null;
  }

  // Stream events are base64-encoded under `bytes`; exception frames are plain.
  final inner = outer['bytes'];
  if (inner is! String) {
    return outer;
  }
  final event = jsonDecode(utf8.decode(base64.decode(inner)));
  return event is Map<String, dynamic> ? event : null;
}
