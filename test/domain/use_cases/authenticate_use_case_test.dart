import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_cases/get_config_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/repositories/iden3comm_repository.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/authenticate_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_auth_token_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_proofs_use_case.dart';
import 'package:polygonid_flutter_sdk/identity/domain/use_cases/get_did_identifier_use_case.dart';

import '../../data/repositories/iden3comm_repository_impl_test.dart';
import 'authenticate_use_case_test.mocks.dart';

MockIden3commRepository iden3commRepository = MockIden3commRepository();
MockGetProofsUseCase getProofsUseCase = MockGetProofsUseCase();
MockGetAuthTokenUseCase getAuthTokenUseCase = MockGetAuthTokenUseCase();
MockGetEnvConfigUseCase getEnvConfigUseCase = MockGetEnvConfigUseCase();
MockGetDidIdentifierUseCase getDidIdentifierUseCase =
    MockGetDidIdentifierUseCase();

AuthenticateUseCase useCase = AuthenticateUseCase(
  iden3commRepository,
  getProofsUseCase,
  getAuthTokenUseCase,
  getEnvConfigUseCase,
  getDidIdentifierUseCase,
);

const issuerMessage = "theIssuerMessage";
const identifier = "theIdentifier";
const pushToken = "thePushToken";
AuthenticateParam param = AuthenticateParam(
    message: mockIden3MessageEntity,
    identifier: identifier,
    pushToken: pushToken);

@GenerateMocks([
  Iden3commRepository,
  GetProofsUseCase,
  GetAuthTokenUseCase,
  GetEnvConfigUseCase,
  GetDidIdentifierUseCase
])
void main() {
  group(
    "Authenticate",
    () {
      setUp(() {
        reset(iden3commRepository);
      });

      test(
        'Given an issuerMessage and a identifier, when we call execute, then we expect that the flow completes without exception',
        () async {
          when(iden3commRepository.authenticate(
            url: anyNamed('url'),
            authToken: anyNamed('authToken'),
          )).thenAnswer((realInvocation) => Future.value());

          await expectLater(useCase.execute(param: param), completes);

          var captured = verify(iden3commRepository.authenticate(
            url: anyNamed('url'),
            authToken: anyNamed('authToken'),
          )).captured;
          expect(captured[0], issuerMessage);
          expect(captured[1], identifier);
        },
      );
    },
  );
}
