import 'dart:convert';
import 'package:flutter_passkey/flutter_passkey.dart';
import 'package:web3dart/crypto.dart';
import 'package:webcrypto/webcrypto.dart';
import 'passkey_option.dart';

class PasskeyHelper {
  static FlutterPasskey flutterPasskeyPlugin = FlutterPasskey();

  static Future<String> getChallengeFromPayload(String payload) async {
    final res = await Hash.sha256.digestBytes(utf8.encode(payload));
    final value = bytesToHex(res, include0x: false);
    var challengeBase64 = utf8.encode(value);
    var challengeBase64Url = base64Encode(challengeBase64);
    challengeBase64Url = challengeBase64Url
        .replaceAll('=', '')
        .replaceAll('-', '+')
        .replaceAll("_", "/");
    return challengeBase64Url;
  }

  static Future<PassKeyCredential?> createPasskey({
    required String challenge,
    required String userId,
    required String userName,
  }) async {
    try {
      final res = await flutterPasskeyPlugin.createCredential(
          getCredentialCreationOptions(
              challenge: challenge, userId: userId, userName: userName));
      final resJson = jsonDecode(res);
      final credentialId = resJson['rawId'];
      final clientDataJson = resJson['response']['clientDataJSON'];
      final attestationObject = resJson['response']['attestationObject'];
      print('credentialId ===== $credentialId');
      return PassKeyCredential(
          credentialId: credentialId,
          clientDataJson: clientDataJson,
          attestationObject: attestationObject);
    } catch (e) {
      print('');
    }
    return null;
  }

  static Future<PassKeySignInfo?> verifyPasskey({
    required String challengeOrigin,
    List<String>? credentialIds,
  }) async {
    final challenge = await getChallengeFromPayload(challengeOrigin);
    try {
      final options = getCredentialRequestOptions(
          challenge: challenge, credentialIds: credentialIds);
      final res = await flutterPasskeyPlugin.getCredential(options);
      final resJson = jsonDecode(res);
      final credentialId = resJson['id'];
      final clientDataJson = resJson['response']['clientDataJSON'];
      final authenticatorData = resJson['response']['authenticatorData'];
      final signature = resJson['response']['signature'];
      print('verifyPasskey credentialId ===== $credentialId');
      return PassKeySignInfo(
          credentialId: credentialId,
          clientDataJson: clientDataJson,
          authenticatorData: authenticatorData,
          signature: signature);
    } catch (e) {
      print(' verifyPasskey error ====== ${e.toString()}');
    }
    return null;
  }
}

class PassKeyCredential {
  final String credentialId;
  final String clientDataJson;
  final String attestationObject;

  PassKeyCredential(
      {required this.credentialId,
      required this.clientDataJson,
      required this.attestationObject});

  PassKeyCredential.from(Map json)
      : credentialId = json['credentialId'],
        clientDataJson = json['clientDataJson'],
        attestationObject = json['attestationObject'];

  Map<String, dynamic> toJson() => {
        'credentialId': credentialId,
        'clientDataJson': clientDataJson,
        'attestationObject': attestationObject,
        'transports': ['AUTHENTICATOR_TRANSPORT_HYBRID'],
      };
}

class PassKeySignInfo {
  final String credentialId;
  final String clientDataJson;
  final String authenticatorData;
  final String signature;

  PassKeySignInfo({
    required this.credentialId,
    required this.clientDataJson,
    required this.authenticatorData,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
        'credentialId': credentialId,
        'clientDataJson': clientDataJson,
        'authenticatorData': authenticatorData,
        'signature': signature,
      };
}
