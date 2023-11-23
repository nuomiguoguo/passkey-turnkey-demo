import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:turnkey_demo/passkey_helper.dart';

const stampHeader = 'X-Stamp-WebAuthn';
const turnKeyBaseUrl = 'https://api.turnkey.com';

class DioRequest {
  ///创建子组织
  static apiCreateSubOrganization({
    required String userEmail,
    required String challenge,
    required PassKeyCredential passKeyCredential,
  }) async {
    final body = {
      'userEmail': userEmail,
      'challenge': challenge,
      'attestation': passKeyCredential.toJson(),
    };
    final jsonString = jsonEncode(body);
    print('jsonString = $jsonString');
    BaseOptions baseOptions = BaseOptions(
      baseUrl: 'https://api-dev.versawallet.io/v1.2',
    );
    try {
      final res = await Dio(baseOptions)
          .post('/tools/turnkey/createSubOrg', data: body);
      print('res ======== $res');
    } catch (e) {
      print('error ======= ${e.toString()}');
    }
  }

  ///add passkey
  static createAuthenticators(
    Map<String, dynamic> body, {
    List<String>? allowedCredentialIds,
  }) async {
    String payload = jsonEncode(body);
    final passkeyInfo = await PasskeyHelper.verifyPasskey(
        challengeOrigin: payload, credentialIds: allowedCredentialIds);
    if (passkeyInfo != null) {
      final baseOptions = BaseOptions(baseUrl: turnKeyBaseUrl, headers: {
        stampHeader: jsonEncode(
          passkeyInfo.toJson(),
        ),
      });
      try {
        final res = await Dio(baseOptions)
            .post('/public/v1/submit/create_authenticators', data: body);
        print(' createAuthenticators res ======== $res');
      } catch (e) {
        print(' createAuthenticators error ======= ${e.toString()}');
      }
    }
  }

  /// get passkey
  static getAuthenticators({
    required String organizationId,
    required String turnKeyUserId,
    List<String>? allowedCredentialIds,
  }) async {
    final body = {
      'organizationId': organizationId,
      'userId': turnKeyUserId,
    };
    String payload = jsonEncode(body);
    final passkeyInfo = await PasskeyHelper.verifyPasskey(
        challengeOrigin: payload, credentialIds: allowedCredentialIds);
    if (passkeyInfo != null) {
      final baseOptions = BaseOptions(baseUrl: turnKeyBaseUrl, headers: {
        stampHeader: jsonEncode(passkeyInfo.toJson()),
      });
      try {
        final res = await Dio(baseOptions)
            .post('/public/v1/query/get_authenticators', data: body);
        print('getAuthenticators res ======== $res');
      } catch (e) {
        print('getAuthenticators error ======= ${e.toString()}');
      }
    }
  }

  ///签名交易
  static signTransaction(
    Map<String, dynamic> body, {
    List<String>? allowedCredentialIds,
  }) async {
    String payload = jsonEncode(body);
    final passkeyInfo = await PasskeyHelper.verifyPasskey(
        challengeOrigin: payload, credentialIds: allowedCredentialIds);
    if (passkeyInfo != null) {
      final baseOptions = BaseOptions(baseUrl: turnKeyBaseUrl, headers: {
        stampHeader: jsonEncode(
          passkeyInfo.toJson(),
        ),
      });
      try {
        final res = await Dio(baseOptions)
            .post('/public/v1/submit/sign_raw_payload', data: body);
        print('res ======== $res');
      } catch (e) {
        print('error ======= ${e.toString()}');
      }
    }
  }
}
