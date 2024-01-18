abstract class PolygonIdException implements Exception {
  StackTrace? stackTrace;
  PolygonIdException([StackTrace? stackTrace]) {
    this.stackTrace = stackTrace ?? StackTrace.current;
  }

  String exceptionInfo() {
    return "";
  }

  String toString() {
    return "[PolygonId Flutter Exception]: $runtimeType\n[info]:\t${exceptionInfo()} \n[StackTrace]:\n$stackTrace\n";
  }
}
