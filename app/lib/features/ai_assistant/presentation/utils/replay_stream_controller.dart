import 'dart:async';

/// A stream controller that replays all previously emitted events to every
/// new subscriber. This lets [Streamdown] widgets re-subscribe after being
/// disposed (e.g. when scrolled off-screen) and still see the full history.
class ReplayStreamController {
  final List<String> _buffer = [];
  final List<StreamController<String>> _sinks = [];
  bool _isClosed = false;

  // Stable stream object — same reference returned on every call so widgets
  // that compare oldWidget.stream == widget.stream don't see a change.
  late final Stream<String> stream = _ReplayStream(this);

  void add(String event) {
    _buffer.add(event);
    for (final sink in _sinks) {
      sink.add(event);
    }
  }

  Future<void> close() async {
    _isClosed = true;
    for (final sink in _sinks) {
      await sink.close();
    }
    _sinks.clear();
  }

  StreamSubscription<String> _subscribe(
    void Function(String)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // Create a fresh single-subscription stream for this listener.
    // Events added before listen() are buffered by StreamController and
    // delivered in order when the subscription starts — no race conditions
    // since Dart is single-threaded.
    final ctrl = StreamController<String>();
    for (final s in _buffer) {
      ctrl.add(s);
    }
    if (_isClosed) {
      unawaited(ctrl.close());
    } else {
      _sinks.add(ctrl);
      ctrl.onCancel = () => _sinks.remove(ctrl);
    }
    return ctrl.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }
}

class _ReplayStream extends Stream<String> {
  _ReplayStream(this._ctrl);
  final ReplayStreamController _ctrl;

  @override
  StreamSubscription<String> listen(
    void Function(String)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => _ctrl._subscribe(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
}
