import 'dart:async';

/// An asynchronous Mutex (mutual exclusion) for Dart.
/// Ensures that only one asynchronous operation (critical section) is executed at a time.
/// Highly useful for protecting database write-after-read sequences and preventing race conditions.
class AsyncMutex {
  Future<void> _last = Future.value();

  /// Protects a critical section of code by forcing sequential execution.
  /// Any subsequent calls to protect will wait for all previously scheduled executions to finish.
  Future<T> protect<T>(FutureOr<T> Function() criticalSection) {
    final completer = Completer<void>();
    final next = _last.then((_) async {
      try {
        return await criticalSection();
      } finally {
        completer.complete();
      }
    });
    _last = completer.future;
    return next;
  }
}
