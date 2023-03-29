import '../../../common/domain/domain_logger.dart';
import '../../../common/domain/entities/filter_entity.dart';
import '../../../common/domain/use_case.dart';
import '../../../identity/domain/exceptions/identity_exceptions.dart';
import '../../../identity/domain/use_cases/get_current_env_did_identifier_use_case.dart';
import '../../../identity/domain/use_cases/identity/get_identity_use_case.dart';
import '../entities/claim_entity.dart';
import '../repositories/credential_repository.dart';

class GetClaimsParam {
  final List<FilterEntity>? filters;
  final String did;
  final int profileNonce;
  final String privateKey;

  GetClaimsParam({
    this.filters,
    required this.did,
    this.profileNonce = 0,
    required this.privateKey,
  });
}

class GetClaimsUseCase
    extends FutureUseCase<GetClaimsParam, List<ClaimEntity>> {
  final CredentialRepository _credentialRepository;
  final GetCurrentEnvDidIdentifierUseCase _getCurrentEnvDidIdentifierUseCase;
  final GetIdentityUseCase _getIdentityUseCase;

  GetClaimsUseCase(this._credentialRepository,
      this._getCurrentEnvDidIdentifierUseCase, this._getIdentityUseCase);

  @override
  Future<List<ClaimEntity>> execute({required GetClaimsParam param}) async {
    // if profileNonce is zero, return all profiles claims,
    // if profileNonce > 0 then return only claims from that profile
    if (param.profileNonce >= 0) {
      if (param.profileNonce > 0) {
        String did = await _getCurrentEnvDidIdentifierUseCase.execute(
            param: GetCurrentEnvDidIdentifierParam(
                privateKey: param.privateKey,
                profileNonce: param.profileNonce));
        return _credentialRepository
            .getClaims(
                filters: param.filters, did: did, privateKey: param.privateKey)
            .then((claims) {
          logger().i("[GetClaimsUseCase] Claims: $claims");
          return claims;
        }).catchError((error) {
          logger().e("[GetClaimsUseCase] Error: $error");
          throw error;
        });
      } else {
        String genesisDid = await _getCurrentEnvDidIdentifierUseCase.execute(
            param:
                GetCurrentEnvDidIdentifierParam(privateKey: param.privateKey));
        var identityEntity = await _getIdentityUseCase.execute(
            param: GetIdentityParam(
                genesisDid: genesisDid, privateKey: param.privateKey));
        List<ClaimEntity> result = [];
        for (var did in identityEntity.profiles.values) {
          List<ClaimEntity> didClaims = await _credentialRepository
              .getClaims(
                  filters: param.filters,
                  did: did,
                  privateKey: param.privateKey)
              .then((claims) {
            logger().i("[GetClaimsUseCase] Claims: $claims");
            return claims;
          }).catchError((error) {
            logger().e("[GetClaimsUseCase] Error: $error");
            throw error;
          });
          result.addAll(didClaims);
        }
        return result;
      }
    } else {
      throw InvalidProfileException(param.profileNonce);
    }
  }
}
