abstract class PolygonIdException implements Exception {
  StackTrace? _stackTrace;
  PolygonIdException([StackTrace? stackTrace]) {
    _stackTrace = stackTrace ?? StackTrace.current;
  }

  String exceptionInfo() {
    return "";
  }

  String toString() {
    return "[PolygonId Flutter Exception]: $runtimeType\n[info]:\t${exceptionInfo()} \n[StackTrace]:\n$_stackTrace\n";
  }
}
