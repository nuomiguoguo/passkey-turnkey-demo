import 'dart:convert';
import 'package:web3dart/crypto.dart';

import 'passkey_helper.dart';
import 'dio_request.dart';
import 'package:web3dart/src/utils/length_tracking_byte_sink.dart';

String toBase64UrlCode(String rawValue) {
  var bytes = utf8.encode(rawValue);
  var value = base64Encode(bytes);
  return value.replaceAll('=', '').replaceAll('-', '+').replaceAll("_", "/");
}

String hashMessage(List<int> userOpHash) {
  const messagePrefix = "\x19Ethereum Signed Message:\n";
  LengthTrackingByteSink sink = LengthTrackingByteSink();
  sink.add(utf8.encode(messagePrefix));
  sink.add(utf8.encode(userOpHash.length.toString()));
  sink.add(userOpHash);
  final res = keccak256(sink.asBytes());
  return bytesToHex(res);
}

class TurnKeyHelper {
  static String getRandomChange({
    required String userEmail,
  }) {
    var challengeOrigin =
        'challenge-$userEmail-${DateTime.now().millisecondsSinceEpoch.toString()}';
    return toBase64UrlCode(challengeOrigin);
  }

  static void createSubOrg({
    required String userEmail,
    required String passkeyUserId, // base64 string
    required String passkeyUserName, //passkey 显示的name
  }) async {
    var challenge = getRandomChange(userEmail: userEmail);
    final res = await PasskeyHelper.createPasskey(
        challenge: challenge, userId: passkeyUserId, userName: passkeyUserName);
    if (res != null) {
      DioRequest.apiCreateSubOrganization(
          userEmail: userEmail, challenge: challenge, passKeyCredential: res);
    }
  }

  static void createNewAuthenticator({
    required String turnkeyOrganizationId,
    required String turnkeyUserId,
    required String passkeyUserId, //base64字符串
    required String passkeyUserName, //passkey 显示的name
    required String userEmail,
    List<String>? allowedCredentialIds,
  }) async {
    var challenge = getRandomChange(userEmail: userEmail);
    final authenticator = await PasskeyHelper.createPasskey(
        challenge: challenge, userId: passkeyUserId, userName: passkeyUserName);
    if (authenticator != null) {
      final requestBody = {
        'type': 'ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2',
        'timestampMs': DateTime.now().millisecondsSinceEpoch.toString(),
        'organizationId': turnkeyOrganizationId,
        'parameters': {
          'authenticators': [
            {
              'authenticatorName': authenticator.credentialId,
              'challenge': challenge,
              'attestation': {
                "credentialId": authenticator.credentialId,
                "clientDataJson": authenticator.clientDataJson,
                "attestationObject": authenticator.attestationObject,
                "transports": ["AUTHENTICATOR_TRANSPORT_HYBRID"]
              }
            }
          ],
          'userId': turnkeyUserId
        }
      };
      DioRequest.createAuthenticators(requestBody,
          allowedCredentialIds: allowedCredentialIds);
    }
  }

  static void signTransaction({
    required String organizationId,
    required String walletAddress,
    required String userOpHash,
    List<String>? allowedCredentialIds,
    //hex string
  }) async {
    final payload = hashMessage(hexToBytes(userOpHash));
    final requestBody = {
      'type': 'ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2',
      'timestampMs': DateTime.now().millisecondsSinceEpoch.toString(),
      'organizationId': organizationId,
      'parameters': {
        'signWith': walletAddress,
        'payload': payload,
        'encoding': 'PAYLOAD_ENCODING_HEXADECIMAL',
        'hashFunction': 'HASH_FUNCTION_NO_OP',
      }
    };
    DioRequest.signTransaction(requestBody,
        allowedCredentialIds: allowedCredentialIds);
  }
}
