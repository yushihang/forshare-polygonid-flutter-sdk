import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:polygonid_flutter_sdk/common/data/exceptions/network_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/data_sources/lib_pidcore_iden3comm_data_source.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/data_sources/remote_iden3comm_data_source.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/dtos/response/auth/auth_body_response.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/dtos/response/auth/auth_response.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/mappers/auth_inputs_mapper.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/mappers/auth_proof_mapper.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/mappers/auth_response_mapper.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/mappers/gist_proof_mapper.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/repositories/iden3comm_repository_impl.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/request/auth/auth_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/repositories/iden3comm_repository.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/circuit_data_entity.dart';

import '../../common/common_mocks.dart';
import 'iden3comm_repository_impl_test.mocks.dart';

// Data
const identifier = "theIdentifier";
const authClaim = "theAuthClaim";
const smt = "smt";

const message = "theMessage";
const signature = "theSignature";
const circuitId = "1";
final datFile = Uint8List(32);
final zKeyFile = Uint8List(32);
final circuitData = CircuitDataEntity(circuitId, datFile, zKeyFile);
const token = "token";
var exception = Exception();

/// We assume [AuthIden3MessageEntity.fromJson] has been tested
const issuerMessage = '''{
    "id":"0b78a480-c710-4bd8-a4fd-454b577ca991",
    "typ":"application/iden3comm-plain-json",
    "type":"https://iden3-communication.io/authorization/1.0/request",
    "thid":"0b78a480-c710-4bd8-a4fd-454b577ca991",
    "body":{"callbackUrl":"https://issuer.polygonid.me/api/callback?sessionId=867314","reason":"test flow","scope":[]},
    "from":"1125GJqgw6YEsKFwj63GY87MMxPL9kwDKxPUiwMLNZ"
    }''';
final mockAuthRequest =
    AuthIden3MessageEntity.fromJson(jsonDecode(issuerMessage));
const wrongIssuerMessage =
    '{"id":"06da1153-59a1-4ed9-9d31-c86b5596a48e","thid":"06da1153-59a1-4ed9-9d31-c86b5596a48e","from":"1125GJqgw6YEsKFwj63GY87MMxPL9kwDKxPUiwMLNZ","typ":"application/iden3comm-plain-json","type":"https://iden3-communication.io/authorization/1.0/request","body":{"reason":"test flow","message":"","scope":[]}}';
final wrongAuthRequest =
    AuthIden3MessageEntity.fromJson(jsonDecode(wrongIssuerMessage));

final mockAuthResponse = AuthResponse(
  id: "id",
  thid: mockAuthRequest.thid,
  to: mockAuthRequest.from,
  from: identifier,
  typ: "application/iden3comm-plain-json",
  type: "https://iden3-communication.io/authorization/1.0/response",
  body: AuthBodyResponse(
    message: mockAuthRequest.body.message,
    proofs: [],
    did_doc: null,
  ),
);

const authResponse = "theAuthResponse";
const pushUrl = "https://push.polygonid.me/api/v1";
const pushToken = "thePushToken";
const didIdentifier = "theDidIdentifier";
const packageName = "thePackageName";

Response errorResponse = Response("body", 450);

// Dependencies
MockRemoteIden3commDataSource remoteIden3commDataSource =
    MockRemoteIden3commDataSource();
MockLibPolygonIdCoreIden3commDataSource libPolygonIdCoreIden3commDataSource =
    MockLibPolygonIdCoreIden3commDataSource();
MockAuthResponseMapper authResponseMapper = MockAuthResponseMapper();
MockAuthInputsMapper authInputsMapper = MockAuthInputsMapper();
MockAuthProofMapper authProofMapper = MockAuthProofMapper();
MockGistProofMapper gistProofMapper = MockGistProofMapper();

// Tested instance
Iden3commRepository repository = Iden3commRepositoryImpl(
  remoteIden3commDataSource,
  libPolygonIdCoreIden3commDataSource,
  authResponseMapper,
  authInputsMapper,
  authProofMapper,
  gistProofMapper,
);

// TODO: verify params
@GenerateMocks([
  RemoteIden3commDataSource,
  LibPolygonIdCoreIden3commDataSource,
  AuthResponseMapper,
  AuthInputsMapper,
  AuthProofMapper,
  GistProofMapper,
])
void main() {
  group(
    "Authenticate",
    () {
      setUp(
        () {
          reset(remoteIden3commDataSource);

          when(authResponseMapper.mapFrom(any))
              .thenAnswer((realInvocation) => "authResponseString");

          when(remoteIden3commDataSource.authWithToken(
            token: anyNamed('token'),
            url: anyNamed('url'),
          )).thenAnswer(
              (realInvocation) => Future.value(Response("body", 200)));
        },
      );

      test(
        'Given an Identifier and a message (iden3message) when we call Authenticate, we expect that flow ended up without exception',
        () async {
          await expectLater(
            repository.authenticate(
              request: mockAuthRequest,
              authToken: token,
            ),
            completes,
          );
        },
      );

      test(
        'Given an Identifier and a message (iden3message) when we call Authenticate and an error is thrown, we expect that flow ended up with exception',
        () async {
          when(remoteIden3commDataSource.authWithToken(
                  token: anyNamed('token'), url: anyNamed('url')))
              .thenThrow(UnknownApiException(450));

          //
          await expectLater(
            repository.authenticate(
              request: mockAuthRequest,
              authToken: token,
            ),
            throwsA(isA<UnknownApiException>()),
          );
        },
      );

      test(
        'Given an Identifier and a message without callback (iden3message) when we call Authenticate and an error is thrown, we expect that flow ended up with a NullAuthenticateCallbackException',
        () async {
          await repository
              .authenticate(
                request: wrongAuthRequest,
                authToken: token,
              )
              .then((_) => expect(true, false))
              .catchError((error) {
            expect(error, isA<NullAuthenticateCallbackException>());
            expect(error.authRequest, wrongAuthRequest);
          });
        },
      );

      test(
          'Given an iden3MessageEntity and an authToken, when we call authenticate a NetworkException is thrown',
          () {
        when(remoteIden3commDataSource.authWithToken(
                token: anyNamed('token'), url: anyNamed('url')))
            .thenAnswer((realInvocation) => Future.value(errorResponse));
        expect(
            repository.authenticate(
              request: mockAuthRequest,
              authToken: token,
            ),
            throwsA(isA<NetworkException>()));
      });
    },
  );

  /// FIXME: cannot UT as [Iden3commRepositoryImpl._getPushCipherText] is internal and call [Http.get]
  // group("Get Auth Response", () {
  //   setUp(() {
  //     reset(authResponseMapper);
  //
  //     when(authResponseMapper.mapFrom(any)).thenReturn(authResponse);
  //   });
  //
  //   test(
  //       "Given an authRequest, when I call getAuthResponse, then I expect an authResponse to be returned",
  //       () async {
  //     // When
  //     expect(
  //       await repository.getAuthResponse(
  //         did: identifier,
  //         request: mockAuthRequest,
  //         pushUrl: pushUrl,
  //         scope: [],
  //         pushToken: pushToken,
  //         didIdentifier: didIdentifier,
  //         packageName: packageName,
  //       ),
  //       authResponse,
  //     );
  //
  //     // Then
  //     AuthResponse authResponseMapperCaptured =
  //         verify(authResponseMapper.mapFrom(captureAny)).captured.first;
  //     expect(authResponseMapperCaptured.thid, mockAuthRequest.thid);
  //     expect(authResponseMapperCaptured.to, mockAuthRequest.from);
  //     expect(authResponseMapperCaptured.from, identifier);
  //   });
  // });
}