class Failure {
  Failure(this.exception, this.st);

  final Object exception;
  final StackTrace st;

  @override
  String toString() {
    return "=================> ERROR: $exception\n$st";
  }
}
