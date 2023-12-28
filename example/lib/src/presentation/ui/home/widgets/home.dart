import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polygonid_flutter_sdk/common/utils/base_64.dart';
import 'package:polygonid_flutter_sdk/common/utils/hex_utils.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/authorization/request/auth_request_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_base_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/interaction/interaction_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/button_next_action.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/feature_card.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/sign/widgets/sign.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resources.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Person {
  String name;
  int age;

  Person({required this.name, required this.age});

  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age};
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _bloc;

  late String did;
  late String privateKey;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<HomeBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGetIdentifier();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Text('\n\n\n\n'),
          Text('A random idea:'),
          Text('A random idea:'),
          TextButton(
            onPressed: () {
              // try {
              //   PolygonIdSdk.I.channel.addIdentity(secret: "1a5f78c0e23b4fa8d87c3bb54e900bf6")
              //     .then((result) {
              //       did = result.did;
              //       privateKey = result.privateKey;
              //       print("addIdentity end: $did");
              //     });
              // } catch (_) {
                PolygonIdSdk.I.channel.getPrivateKey(secret: "1a5f78c0e23b4fa8d87c3bb54e900bf6").then((value) {
                  privateKey = value;
                  PolygonIdSdk.I.channel.getDidIdentifier(privateKey: privateKey, blockchain: "polygon", network: "mumbai").then((value) {
                    did = value;
                    print("addIdentity end: $did");
                  });
                });
              // }
            },
            style: TextButton.styleFrom(
              primary: Colors.red, // 指定文本颜色为红色
            ),
            child: Text('addIdentity'),
          ),
          TextButton(
            onPressed: () {
              authenticate(did, privateKey)
                .then((value){
                  print("authenticate end");
                });

            },
            style: TextButton.styleFrom(
              primary: Colors.red, // 指定文本颜色为红色
            ),
            child: Text('authenticate'),
          ),
          TextButton(
            onPressed: () {
              fetchAndSaveClaims(did, privateKey)
                .then((value){
                  print(value);
                  print("fetchAndSaveClaims end");
                });
            },
            style: TextButton.styleFrom(
              primary: Colors.red, // 指定文本颜色为红色
            ),
            child: Text('fetchAndSaveClaims'),
          ),
          TextButton(
            onPressed: () {
              getProofs(did, privateKey)
                .then((value){
                  print("getProofs end");
                });

            },
            style: TextButton.styleFrom(
              primary: Colors.red, // 指定文本颜色为红色
            ),
            child: Text('getProofs'),
          ),
        ],
        
      ),
    );
  }

  Future<void> authenticate( String genesisDid, String privateKey) async {
    String jsonString = """
            {"id":"0977e1df-9c72-4c5f-9bb0-7b4d9f5d608e","typ":"application/iden3comm-plain-json","type":"https://iden3-communication.io/authorization/1.0/request","thid":"0977e1df-9c72-4c5f-9bb0-7b4d9f5d608e","body":{"callbackUrl":"https://self-hosted-testing-testnet-backend-platform.polygonid.me/api/callback?sessionId=983270","reason":"test flow","scope":[]},"from":"did:polygonid:polygon:mumbai:2qFXmNqGWPrLqDowKz37Gq2FETk4yQwVUVUqeBLmf9"}
    """;
    Map<String, dynamic> json = jsonDecode(jsonString);
    AuthIden3MessageEntity message = AuthIden3MessageEntity.fromJson(json);
    return PolygonIdSdk.I.channel.authenticate(message: message, genesisDid: genesisDid, privateKey: privateKey);
  }

  Future<List<ClaimEntity>> fetchAndSaveClaims( String genesisDid, String privateKey) async {
    String jsonString = """
{
"id": "be777afe-4f4f-417d-a390-298292c7f103",
"typ": "application/iden3comm-plain-json",
"type": "https://iden3-communication.io/credentials/1.0/offer",
"thid": "be777afe-4f4f-417d-a390-298292c7f103",
"body": {
"url": "https://issuer-admin.polygonid.me/v1/agent",
"credentials": [
{
"id": "47c4392f-a4a3-11ee-93b5-0242ac120009",
"description": "POAP01"
}
]
},
"from": "did:polygonid:polygon:mumbai:2qMCebtitXNzau92r4JNV3y162hkzVZPn75UPMiE1G",
"to": "did:polygonid:polygon:mumbai:2qDmykxfdvrwryPTDZAXsZY5S4V3Jy8vCWj8mPgsnS"
}
    """;
    Map<String, dynamic> json = jsonDecode(jsonString);
    OfferIden3MessageEntity message = OfferIden3MessageEntity.fromJson(json);
    return PolygonIdSdk.I.channel.fetchAndSaveClaims(message: message, genesisDid: genesisDid, privateKey: privateKey);
  }

  Future<void> getProofs( String genesisDid, String privateKey) async {
    String jsonString3 = """
                        {
                            "id":"2dd99e29-b387-4096-935d-3c3979d88b5e",
                            "typ":"application/iden3comm-plain-json",
                            "type":"https://iden3-communication.io/authorization/1.0/request",
                            "thid":"2dd99e29-b387-4096-935d-3c3979d88b5e",
                            "body":{
                                "callbackUrl":"https://self-hosted-demo-backend-platform.polygonid.me/api/callback?sessionId=271535",
                                "reason":"test flow",
                                "scope":[
                                    {
                                        "id":1,
                                        "circuitId":"credentialAtomicQuerySigV2",
                                        "query":{
                                            "allowedIssuers":[
                                                "*"
                                            ],
                                            "context":"ipfs://QmdH1Vu79p2NcZLFbHxzJnLuUHJiMZnBeT7SNpLaqK7k9X",
                                            "credentialSubject":{
                                                "city":{
                                                    "\$eq":"Guangzhou"
                                                }
                                            },
                                            "type":"POAP01"
                                        }
                                    }
                                ]
                            },
                            "from":"did:polygonid:polygon:mumbai:2qH7TstpRRJHXNN4o49Fu9H2Qismku8hQeUxDVrjqT"
                        }
                """;

    Map<String, dynamic> json3 = jsonDecode(jsonString3);
      AuthIden3MessageEntity messsage3;
      
      try {
        messsage3 = AuthIden3MessageEntity.fromJson(json3);
      } catch (e) {
        messsage3 = AuthIden3MessageEntity.fromJson(json3);
      }
      return PolygonIdSdk.I.channel.getProofs(message: messsage3,
       genesisDid: genesisDid,
        privateKey: privateKey,
         ethereumUrl: "https://polygon-mumbai.infura.io/v3/5a438c5b50094ee3b0ed1df8f4bb3f44", 
         stateContractAddr: "0x134B1BE34911E39A8397ec6289782989729807a4", 
         ipfsNodeUrl: "https://ipfs.io")
        .then((message) => jsonEncode(message))
        .then((result) {
            print(result);
          });
  }


  ///
  void _initGetIdentifier() {
    _bloc.add(const GetIdentifierHomeEvent());
  }

  ///
  Widget _buildIdentityActionButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, HomeState state) {
          bool enabled = state is! LoadingDataHomeState;
          bool showCreateIdentityButton =
              state.identifier == null || state.identifier!.isEmpty;

          return showCreateIdentityButton
              ? _buildCreateIdentityButton(enabled)
              : _buildRemoveIdentityButton(enabled);
        },
      ),
    );
  }

  ///
  Widget _buildCreateIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: ElevatedButton(
        key: CustomWidgetsKeys.homeScreenButtonCreateIdentity,
        onPressed: () {
          _bloc.add(const HomeEvent.createIdentity());
        },
        style: enabled
            ? CustomButtonStyle.primaryButtonStyle
            : CustomButtonStyle.disabledPrimaryButtonStyle,
        child: const FittedBox(
          child: Text(
            CustomStrings.homeButtonCTA,
            textAlign: TextAlign.center,
            style: CustomTextStyles.primaryButtonTextStyle,
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildRemoveIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: ElevatedButton(
        key: CustomWidgetsKeys.homeScreenButtonRemoveIdentity,
        onPressed: () {
          _bloc.add(const HomeEvent.removeIdentity());
        },
        style: enabled
            ? CustomButtonStyle.outlinedPrimaryButtonStyle
            : CustomButtonStyle.disabledPrimaryButtonStyle,
        child: FittedBox(
          child: Text(
            CustomStrings.homeButtonRemoveIdentityCTA,
            textAlign: TextAlign.center,
            style: CustomTextStyles.primaryButtonTextStyle.copyWith(
              color: CustomColors.primaryButton,
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildLogo() {
    return SvgPicture.asset(
      ImageResources.logo,
      width: 120,
    );
  }

  ///
  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.homeDescription,
        textAlign: TextAlign.center,
        style: CustomTextStyles.descriptionTextStyle,
      ),
    );
  }

  ///
  Widget _buildProgress() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        if (state is! LoadingDataHomeState) return const SizedBox.shrink();
        return const SizedBox(
          height: 48,
          width: 48,
          child: CircularProgressIndicator(
            backgroundColor: CustomColors.primaryButton,
          ),
        );
      },
    );
  }

  ///
  Widget _buildIdentifierSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            CustomStrings.homeIdentifierSectionPrefix,
            textAlign: TextAlign.center,
            style: CustomTextStyles.descriptionTextStyle.copyWith(fontSize: 20),
          ),
          BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, HomeState state) {
              return Text(
                state.identifier ??
                    CustomStrings.homeIdentifierSectionPlaceHolder,
                key: const Key('identifier'),
                style: CustomTextStyles.descriptionTextStyle
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              );
            },
            buildWhen: (_, currentState) =>
                currentState is LoadedIdentifierHomeState,
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildErrorSection() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        if (state is! ErrorHomeState) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            state.message,
            style: CustomTextStyles.descriptionTextStyle
                .copyWith(color: CustomColors.redError),
          ),
        );
      },
    );
  }

  ///
  Widget _buildNavigateToNextPageButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, HomeState state) {
            bool enabled = (state is! LoadingDataHomeState) &&
                (state.identifier != null && state.identifier!.isNotEmpty);
            return ButtonNextAction(
              key: CustomWidgetsKeys.homeScreenButtonNextAction,
              enabled: enabled,
              onPressed: () {
                Navigator.pushNamed(context, Routes.authPath);
              },
            );
          },
        ),
      ),
    );
  }

  ///
  Widget _buildSignMessageSection() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        if (state.identifier == null || state.identifier!.isEmpty) {
          return const SizedBox.shrink();
        }
        return SignWidget();
      },
      buildWhen: (_, currentState) => currentState is LoadedIdentifierHomeState,
    );
  }

  ///
  Widget _buildFeaturesSection() {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        _buildSignMessageFeatureCard(),
        _buildAuthenticateFeatureCard(),
        _buildCheckIdentityValidityFeatureCard(),
        _buildBackupIdentityFeatureCard(),
        _buildRestoreIdentityFeatureCard(),
      ],
    );
  }

  ///
  Widget _buildSignMessageFeatureCard() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        bool enabled = (state is! LoadingDataHomeState) &&
            (state.identifier != null && state.identifier!.isNotEmpty);
        return FeatureCard(
          methodName: CustomStrings.signMessageMethod,
          title: CustomStrings.signMessageTitle,
          description: CustomStrings.signMessageDescription,
          onTap: () {
            Navigator.pushNamed(context, Routes.signMessagePath);
          },
          enabled: enabled,
          disabledReason: CustomStrings.homeFeatureCardDisabledReason,
        );
      },
    );
  }

  ///
  Widget _buildAuthenticateFeatureCard() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        bool enabled = (state is! LoadingDataHomeState) &&
            (state.identifier != null && state.identifier!.isNotEmpty);
        return FeatureCard(
          methodName: CustomStrings.authenticateMethod,
          title: CustomStrings.authenticateTitle,
          description: CustomStrings.authenticateDescription,
          onTap: () {
            Navigator.pushNamed(context, Routes.authPath);
          },
          enabled: enabled,
          disabledReason: CustomStrings.homeFeatureCardDisabledReason,
        );
      },
    );
  }

  ///
  Widget _buildCheckIdentityValidityFeatureCard() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        bool enabled = (state is! LoadingDataHomeState) &&
            (state.identifier != null && state.identifier!.isNotEmpty);
        return FeatureCard(
          methodName: CustomStrings.checkIdentityValidityMethod,
          title: CustomStrings.checkIdentityValidityTitle,
          description: CustomStrings.checkIdentityValidityDescription,
          onTap: () {
            Navigator.pushNamed(context, Routes.checkIdentityValidityPath);
          },
          enabled: enabled,
          disabledReason: CustomStrings.homeFeatureCardDisabledReason,
        );
      },
    );
  }

  ///
  Widget _buildBackupIdentityFeatureCard() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        bool enabled = (state is! LoadingDataHomeState) &&
            (state.identifier != null && state.identifier!.isNotEmpty);
        return FeatureCard(
          methodName: CustomStrings.backupIdentityMethod,
          title: CustomStrings.backupIdentityTitle,
          description: CustomStrings.backupIdentityDescription,
          onTap: () {
            Navigator.pushNamed(context, Routes.backupIdentityPath);
          },
          enabled: enabled,
          disabledReason: CustomStrings.homeFeatureCardDisabledReason,
        );
      },
    );
  }

  ///
  Widget _buildRestoreIdentityFeatureCard() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, HomeState state) {
        bool enabled = (state is! LoadingDataHomeState) &&
            (state.identifier != null && state.identifier!.isNotEmpty);
        return FeatureCard(
          methodName: CustomStrings.restoreIdentityMethod,
          title: CustomStrings.restoreIdentityTitle,
          description: CustomStrings.restoreIdentityDescription,
          onTap: () {
            Navigator.pushNamed(context, Routes.restoreIdentityPath);
          },
          enabled: enabled,
          disabledReason: CustomStrings.homeFeatureCardDisabledReason,
        );
      },
    );
  }
}
