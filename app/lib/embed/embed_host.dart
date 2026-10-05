/// The page hosting the app, on the web; a stub elsewhere.
library;

export 'embed_host_stub.dart' if (dart.library.js_interop) 'embed_host_web.dart';
export 'embed_protocol.dart';
