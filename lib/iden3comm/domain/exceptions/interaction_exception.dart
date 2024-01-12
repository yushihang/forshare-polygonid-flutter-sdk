import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_base_entity.dart';

class InteractionNotFoundException extends PolygonIdException {
  final String id;

  InteractionNotFoundException(this.id);

  @override
  String exceptionInfo() {
    return "id: $id";
  }
}

class InvalidInteractionType extends PolygonIdException {
  final InteractionType type;

  InvalidInteractionType(this.type);

  @override
  String exceptionInfo() {
    return "type: $type";
  }
}
