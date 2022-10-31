// Mocks generated by Mockito 5.3.2 from annotations
// in polygonid_flutter_sdk/test/data/repositories/identity_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;
import 'dart:typed_data' as _i10;

import 'package:mockito/mockito.dart' as _i1;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/lib_identity_data_source.dart'
    as _i11;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/remote_identity_data_source.dart'
    as _i13;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/rpc_data_source.dart'
    as _i17;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/storage_identity_data_source.dart'
    as _i14;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/storage_key_value_data_source.dart'
    as _i16;
import 'package:polygonid_flutter_sdk/identity/data/data_sources/wallet_data_source.dart'
    as _i8;
import 'package:polygonid_flutter_sdk/identity/data/dtos/identity_dto.dart'
    as _i4;
import 'package:polygonid_flutter_sdk/identity/data/dtos/rhs_node_dto.dart'
    as _i3;
import 'package:polygonid_flutter_sdk/identity/data/mappers/hex_mapper.dart'
    as _i18;
import 'package:polygonid_flutter_sdk/identity/data/mappers/identity_dto_mapper.dart'
    as _i20;
import 'package:polygonid_flutter_sdk/identity/data/mappers/private_key_mapper.dart'
    as _i19;
import 'package:polygonid_flutter_sdk/identity/data/mappers/rhs_node_mapper.dart'
    as _i21;
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart'
    as _i6;
import 'package:polygonid_flutter_sdk/identity/domain/entities/rhs_node_entity.dart'
    as _i7;
import 'package:polygonid_flutter_sdk/identity/domain/repositories/smt_storage_repository.dart'
    as _i12;
import 'package:polygonid_flutter_sdk/identity/libs/bjj/privadoid_wallet.dart'
    as _i2;
import 'package:sembast/sembast.dart' as _i15;
import 'package:web3dart/web3dart.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePrivadoIdWallet_0 extends _i1.SmartFake
    implements _i2.PrivadoIdWallet {
  _FakePrivadoIdWallet_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRhsNodeDTO_1 extends _i1.SmartFake implements _i3.RhsNodeDTO {
  _FakeRhsNodeDTO_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIdentityDTO_2 extends _i1.SmartFake implements _i4.IdentityDTO {
  _FakeIdentityDTO_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWeb3Client_3 extends _i1.SmartFake implements _i5.Web3Client {
  _FakeWeb3Client_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIdentityEntity_4 extends _i1.SmartFake
    implements _i6.IdentityEntity {
  _FakeIdentityEntity_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRhsNodeEntity_5 extends _i1.SmartFake implements _i7.RhsNodeEntity {
  _FakeRhsNodeEntity_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WalletDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletDataSource extends _i1.Mock implements _i8.WalletDataSource {
  MockWalletDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<_i2.PrivadoIdWallet> createWallet({_i10.Uint8List? privateKey}) =>
      (super.noSuchMethod(
        Invocation.method(
          #createWallet,
          [],
          {#privateKey: privateKey},
        ),
        returnValue:
            _i9.Future<_i2.PrivadoIdWallet>.value(_FakePrivadoIdWallet_0(
          this,
          Invocation.method(
            #createWallet,
            [],
            {#privateKey: privateKey},
          ),
        )),
      ) as _i9.Future<_i2.PrivadoIdWallet>);
  @override
  _i9.Future<String> signMessage({
    required _i10.Uint8List? privateKey,
    required String? message,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signMessage,
          [],
          {
            #privateKey: privateKey,
            #message: message,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
}

/// A class which mocks [LibIdentityDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockLibIdentityDataSource extends _i1.Mock
    implements _i11.LibIdentityDataSource {
  MockLibIdentityDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<String> getIdentifier({
    required String? pubX,
    required String? pubY,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getIdentifier,
          [],
          {
            #pubX: pubX,
            #pubY: pubY,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  String getDidIdentifier({
    required String? identifier,
    required String? networkName,
    required String? networkEnv,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDidIdentifier,
          [],
          {
            #identifier: identifier,
            #networkName: networkName,
            #networkEnv: networkEnv,
          },
        ),
        returnValue: '',
      ) as String);
  @override
  _i9.Future<String> getAuthClaim({
    required String? pubX,
    required String? pubY,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAuthClaim,
          [],
          {
            #pubX: pubX,
            #pubY: pubY,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<String> createSMT(
          _i12.SMTStorageRepository? smtStorageRepository) =>
      (super.noSuchMethod(
        Invocation.method(
          #createSMT,
          [smtStorageRepository],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<String> getId(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getId,
          [id],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
}

/// A class which mocks [RemoteIdentityDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteIdentityDataSource extends _i1.Mock
    implements _i13.RemoteIdentityDataSource {
  MockRemoteIdentityDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<_i3.RhsNodeDTO> fetchStateRoots({required String? url}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchStateRoots,
          [],
          {#url: url},
        ),
        returnValue: _i9.Future<_i3.RhsNodeDTO>.value(_FakeRhsNodeDTO_1(
          this,
          Invocation.method(
            #fetchStateRoots,
            [],
            {#url: url},
          ),
        )),
      ) as _i9.Future<_i3.RhsNodeDTO>);
  @override
  _i9.Future<Map<String, dynamic>> nonRevProof(
    int? revNonce,
    String? id,
    String? rhsBaseUrl,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #nonRevProof,
          [
            revNonce,
            id,
            rhsBaseUrl,
          ],
        ),
        returnValue:
            _i9.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i9.Future<Map<String, dynamic>>);
}

/// A class which mocks [StorageIdentityDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageIdentityDataSource extends _i1.Mock
    implements _i14.StorageIdentityDataSource {
  MockStorageIdentityDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<_i4.IdentityDTO> getIdentity({required String? identifier}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getIdentity,
          [],
          {#identifier: identifier},
        ),
        returnValue: _i9.Future<_i4.IdentityDTO>.value(_FakeIdentityDTO_2(
          this,
          Invocation.method(
            #getIdentity,
            [],
            {#identifier: identifier},
          ),
        )),
      ) as _i9.Future<_i4.IdentityDTO>);
  @override
  _i9.Future<void> storeIdentity({
    required String? identifier,
    required _i4.IdentityDTO? identity,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeIdentity,
          [],
          {
            #identifier: identifier,
            #identity: identity,
          },
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> storeIdentityTransact({
    required _i15.DatabaseClient? transaction,
    required String? identifier,
    required _i4.IdentityDTO? identity,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeIdentityTransact,
          [],
          {
            #transaction: transaction,
            #identifier: identifier,
            #identity: identity,
          },
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> removeIdentity({required String? identifier}) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeIdentity,
          [],
          {#identifier: identifier},
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> removeIdentityTransact({
    required _i15.DatabaseClient? transaction,
    required String? identifier,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeIdentityTransact,
          [],
          {
            #transaction: transaction,
            #identifier: identifier,
          },
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
}

/// A class which mocks [StorageKeyValueDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageKeyValueDataSource extends _i1.Mock
    implements _i16.StorageKeyValueDataSource {
  MockStorageKeyValueDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.Future<dynamic> get({
    required String? key,
    _i15.DatabaseClient? database,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
          {
            #key: key,
            #database: database,
          },
        ),
        returnValue: _i9.Future<dynamic>.value(),
      ) as _i9.Future<dynamic>);
  @override
  _i9.Future<void> store({
    required String? key,
    required dynamic value,
    _i15.DatabaseClient? database,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #store,
          [],
          {
            #key: key,
            #value: value,
            #database: database,
          },
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<String?> remove({
    required String? key,
    _i15.DatabaseClient? database,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
          {
            #key: key,
            #database: database,
          },
        ),
        returnValue: _i9.Future<String?>.value(),
      ) as _i9.Future<String?>);
}

/// A class which mocks [RPCDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRPCDataSource extends _i1.Mock implements _i17.RPCDataSource {
  MockRPCDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Web3Client get web3Client => (super.noSuchMethod(
        Invocation.getter(#web3Client),
        returnValue: _FakeWeb3Client_3(
          this,
          Invocation.getter(#web3Client),
        ),
      ) as _i5.Web3Client);
  @override
  _i9.Future<String> getState(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getState,
          [id],
        ),
        returnValue: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
}

/// A class which mocks [HexMapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockHexMapper extends _i1.Mock implements _i18.HexMapper {
  MockHexMapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String mapFrom(_i10.Uint8List? from) => (super.noSuchMethod(
        Invocation.method(
          #mapFrom,
          [from],
        ),
        returnValue: '',
      ) as String);
  @override
  _i10.Uint8List mapTo(String? to) => (super.noSuchMethod(
        Invocation.method(
          #mapTo,
          [to],
        ),
        returnValue: _i10.Uint8List(0),
      ) as _i10.Uint8List);
}

/// A class which mocks [PrivateKeyMapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrivateKeyMapper extends _i1.Mock implements _i19.PrivateKeyMapper {
  MockPrivateKeyMapper() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [IdentityDTOMapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockIdentityDTOMapper extends _i1.Mock implements _i20.IdentityDTOMapper {
  MockIdentityDTOMapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.IdentityEntity mapFrom(_i4.IdentityDTO? from) => (super.noSuchMethod(
        Invocation.method(
          #mapFrom,
          [from],
        ),
        returnValue: _FakeIdentityEntity_4(
          this,
          Invocation.method(
            #mapFrom,
            [from],
          ),
        ),
      ) as _i6.IdentityEntity);
}

/// A class which mocks [RhsNodeMapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockRhsNodeMapper extends _i1.Mock implements _i21.RhsNodeMapper {
  MockRhsNodeMapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.RhsNodeEntity mapFrom(_i3.RhsNodeDTO? from) => (super.noSuchMethod(
        Invocation.method(
          #mapFrom,
          [from],
        ),
        returnValue: _FakeRhsNodeEntity_5(
          this,
          Invocation.method(
            #mapFrom,
            [from],
          ),
        ),
      ) as _i7.RhsNodeEntity);
  @override
  _i3.RhsNodeDTO mapTo(_i7.RhsNodeEntity? to) => (super.noSuchMethod(
        Invocation.method(
          #mapTo,
          [to],
        ),
        returnValue: _FakeRhsNodeDTO_1(
          this,
          Invocation.method(
            #mapTo,
            [to],
          ),
        ),
      ) as _i3.RhsNodeDTO);
}
