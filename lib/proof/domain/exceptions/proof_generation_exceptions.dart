import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

class ProofGenerationException extends ErrorException {
  ProofGenerationException(error) : super(error);
}

class NullAtomicQueryInputsException extends PolygonIdException {
  final String? id;
  final String? errorMessage;

  NullAtomicQueryInputsException(this.id, {this.errorMessage});

  @override
  String exceptionInfo() {
    return "id: $id, errorMessage: $errorMessage";
  }
}

class NullWitnessException extends PolygonIdException {
  final String? circuit;

  NullWitnessException(this.circuit);

  @override
  String exceptionInfo() {
    return "circuit: $circuit";
  }
}

class GenerateNonRevProofException extends ErrorException {
  GenerateNonRevProofException(error) : super(error);
}

class NullProofException extends PolygonIdException {
  final String? circuit;

  NullProofException(this.circuit);

  @override
  String exceptionInfo() {
    return "circuit: $circuit";
  }
}

class FetchGistProofException extends ErrorException {
  FetchGistProofException(error) : super(error);
}

class ProofInputsException extends PolygonIdException {
  final String? errorMessage;

  ProofInputsException(this.errorMessage);

  @override
  String exceptionInfo() {
    return "errorMessage: $errorMessage";
  }
}
