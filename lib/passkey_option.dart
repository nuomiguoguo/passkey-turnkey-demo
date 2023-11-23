import 'dart:convert';
import 'dart:io';

const rpId = 'api-dev.versawallet.io';

String getCredentialCreationOptions({
  required String challenge,
  required String userId,
  required String userName,
}) {
  // Obtain this from the server
  if (Platform.isAndroid) {
    return jsonEncode({
      "challenge": challenge,
      "rp": {"name": "Versa Wallet Test", "id": rpId},
      "user": {"id": userId, "name": userName, "displayName": userName},
      "pubKeyCredParams": [
        {
          "type": "public-key",
          "alg": -7,
        },
        // {
        //   "type": "public-key",
        //   "alg": -257
        // }
      ],
      "timeout": 30000,
      "attestation": "none",
      "excludeCredentials": [],
      "authenticatorSelection": {
        "authenticatorAttachment": "platform",
        "requireResidentKey": true,
        "residentKey": "required",
        "userVerification": "required"
      }
    });
  }
  return jsonEncode({
    "challenge": challenge,
    "rpId": rpId,
    "user": {"id": userId, "name": userName},
    "pubKeyCredParams": [
      {
        'alg': -7,
      }
    ],
    "authenticatorSelection": {
      "userVerification": "preferred",
      "residentKey": "preferred",
    },
    "authenticatorSelection":{
      "authenticatorAttachment": "cross-platform",
    }
  });
}

String getCredentialRequestOptions({
  required String challenge,
  List<String>? credentialIds,
}) {
  final credentials = [];
  if (credentialIds?.isNotEmpty ?? false) {
    credentials.addAll(credentialIds!
        .map((e) => {
              "id": e,
              "type": "public-key",
              'transports': ["internal", "hybrid"],
            })
        .toList());
  }
  return jsonEncode({
    "challenge": challenge,
    "rpId": rpId,
    "pubKeyCredParams": [
      {
        'alg': -7,
      }
    ],
    "authenticatorSelection": {
      "userVerification": "preferred",
      "residentKey": "preferred",
    },
    "allowCredentials": credentials,
    // "allowCredentials": [
    //   {
    //     "id": "-n-PJOwUeoq61JvvThMzRw12",
    //     "type": "public-key",
    //     'transports': ["internal", "hybrid"],
    //   },
    //   {
    //     "id": "hK_c54oSNCHawix97TByjw",
    //     "type": "public-key",
    //     'transports': ["internal", "hybrid"],
    //   }
    // ]
    // "allowCredentials": [
    //   {"id": "VkbcnT14eVCTO38hJniGEg"}
    // ]
  });
}
