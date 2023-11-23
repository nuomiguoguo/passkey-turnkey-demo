import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turnkey_demo/dio_request.dart';
import 'package:turnkey_demo/passkey_helper.dart';
import 'package:turnkey_demo/turnkey_helper.dart';
import 'package:web3dart/crypto.dart';
import 'package:webcrypto/webcrypto.dart';
import 'package:web3dart/web3dart.dart';
// import 'package:ecdsa/ecdsa.dart';
import 'package:web3dart/src/utils/length_tracking_byte_sink.dart';

// const passkeyUserId = 'bmljay0wMQ=='; //nick-01
// const passkeyUserName = 'nick';
const turnKeyOrganizationId = 'a55431db-9e63-4259-bdb9-0e9bfbf1c892';
const turnKeyUserId = 'd3e71efa-0a93-4d7a-91e4-c201d24f0c05';
const turnKeyWalletAddress = '0x6e216cFB58d46F174442AE15DAE76388b7f6FC8E';

void main() {
  const userOpHash =
      '0x588e4e2885dc64d966c7bdaaf7ffeca3234132a7c292282ee5c64d2e8ae8a09f';
  final payload = hashMessage(hexToBytes(userOpHash));
  print('payload ======= $payload');

  // BigInt r = BigInt.parse('376f94f1ff5de8f62691581f9803341b9b6454a5fdcf671c2118aad63168bd98',radix: 16);
  // BigInt s = BigInt.parse('3da50539477eaeab6fae2b5a3aa75e23e45a40238bac7dd68217ed26b91604e9',radix: 16);
  // int v = 01;
  // final res = EthSignature.fromRSV(r, s, v);
  // print('res ===== ${res.toString()}');
  // print('res1=== ${res.toEthCompactHex()}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                const userEmail = 'nick@test.com';
                TurnKeyHelper.createSubOrg(
                    userEmail: userEmail,
                    passkeyUserId: base64Encode(utf8.encode(userEmail)),
                    passkeyUserName: userEmail);
                // createSubOrg();
                // var challenge =
                //     TurnKeyHelper.getRandomChange(userEmail: '888@qq.com');

                // PasskeyHelper.createPasskey(
                //     challenge: challenge,
                //     userId: base64Encode(utf8.encode('nick-03')),
                //     userName: 'nick-03');
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: const Text('create passkey'),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // createNewAuthenticator(
                    //     organizationId: turnKeyOrganizationId,
                    //     userId: turnKeyUserId);
                    // getChallengeFromPayload('123');
                    var challenge =
                        TurnKeyHelper.getRandomChange(userEmail: '888@qq.com');
                    PasskeyHelper.verifyPasskey(
                        challengeOrigin: challenge,
                        credentialIds: ['-n-PJOwUeoq61JvvThMzRw']);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: const Text('verify passkey'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DioRequest.getAuthenticators(
                        organizationId: turnKeyOrganizationId,
                        turnKeyUserId: turnKeyUserId);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.black,
                    child: const Text('get passkey'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () {
                TurnKeyHelper.signTransaction(
                  organizationId: turnKeyOrganizationId,
                  walletAddress: turnKeyWalletAddress,
                  userOpHash:
                      '0x588e4e2885dc64d966c7bdaaf7ffeca3234132a7c292282ee5c64d2e8ae8a09f',
                );
                // signTransaction(
                //     organizationId: turnKeyOrganizationId,
                //     walletAddress: turnKeyWalletAddress);
              },
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Text('sign transaction')),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void getAuths() async {
  DioRequest.getAuthenticators(
    organizationId: '5a29487c-f6c3-41ea-b351-53b841856570',
    turnKeyUserId: '080527c5-8fc3-42bf-ab26-38ec6898541c',
  );
}

// void verify() async {
//   // test1('123');
//
//   const userEmail = '412237050@qq.com';
//   var challengeOrigin =
//       'challenge-$userEmail-${DateTime.now().millisecondsSinceEpoch.toString()}';
//
//   var bytes = utf8.encode(challengeOrigin);
//   var challenge = base64Encode(bytes);
//   challenge = challenge.replaceAll('=', '');
//
//   final res = await PasskeyHelper.createPasskey(
//       challenge: challenge, userId: passkeyUserId, userName: passkeyUserName);
//   if (res != null) {
//     final res1 = await PasskeyHelper.verifyPasskey(challengeOrigin: challenge);
//     if (res1 != null) {
//       // DioRequest.createAuthenticators(body)
//     }
//   }
// }

// void createSubOrg() async {
//   // test1('124');
//   // return;
//   // p256Ask();
//   // return;
//   const userEmail = '412237050@163.com';
//   var challengeOrigin =
//       'challenge-$userEmail-${DateTime.now().millisecondsSinceEpoch.toString()}';
//
//   var bytes = utf8.encode(challengeOrigin);
//   var challenge = base64Encode(bytes);
//   challenge = challenge.replaceAll('=', '');
//
//   final res = await PasskeyHelper.createPasskey(
//       challenge: challenge, userId: passkeyUserId, userName: passkeyUserName);
//   if (res != null) {
//     DioRequest.apiCreateSubOrganization(
//         userEmail: userEmail, challenge: challenge, passKeyCredential: res);
//     // Map<String, dynamic> bodyMap = {
//     //   'type': 'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V4',
//     //   'timestampMs': DateTime.now().millisecondsSinceEpoch.toString(),
//     //   'organizationId': 'a05c9eea-e224-4569-909f-a478dc3585bd',
//     //   'parameters': {
//     //     'subOrganizationName': 'versa-demo-sub01',
//     //     'rootQuorumThreshold': 1,
//     //     'rootUsers': [
//     //       {
//     //         'userName': "versa-demo-user1-name",
//     //         "userEmail": "412237050@qq.com",
//     //         'apiKeys': [],
//     //         'authenticators': [
//     //           {
//     //             'authenticatorName': "Passkey-01",
//     //             'challenge': 'challenge_test',
//     //             'attestation': {
//     //               "credentialId": res.credentialId,
//     //               "clientDataJson": res.clientDataJson,
//     //               "attestationObject": res.attestationObject,
//     //               "transports": ["AUTHENTICATOR_TRANSPORT_HYBRID"]
//     //             }
//     //           },
//     //         ]
//     //       },
//     //     ],
//     //     "wallet": {
//     //       "walletName": "versa-demo-wallet-01",
//     //       "accounts": [
//     //         {
//     //           "curve": "CURVE_SECP256K1",
//     //           "pathFormat": "PATH_FORMAT_BIP32",
//     //           "path": "m/44'/60'/0'/0/0",
//     //           "addressFormat": "ADDRESS_FORMAT_ETHEREUM",
//     //         },
//     //       ],
//     //     },
//     //   }
//     // };
//     // DioRequest.createSubOrganization(bodyMap);
//   }
// }

// void createNewAuthenticator({
//   required String organizationId,
//   required String userId,
// }) async {
//   const userEmail = '412237050@163.com';
//   var challengeOrigin =
//       'challenge-$userEmail-${DateTime.now().millisecondsSinceEpoch.toString()}';
//
//   var bytes = utf8.encode(challengeOrigin);
//   var challenge = base64Encode(bytes);
//   challenge = challenge.replaceAll('=', '');
//   final authenticator = await PasskeyHelper.createPasskey(
//       challenge: challenge, userId: passkeyUserId, userName: passkeyUserName);
//   if (authenticator != null) {
//     final requestBody = {
//       'type': 'ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2',
//       'timestampMs': DateTime.now().millisecondsSinceEpoch.toString(),
//       'organizationId': organizationId,
//       'parameters': {
//         'authenticators': [
//           {
//             'authenticatorName': authenticator.credentialId,
//             'challenge': challenge,
//             'attestation': {
//               "credentialId": authenticator.credentialId,
//               "clientDataJson": authenticator.clientDataJson,
//               "attestationObject": authenticator.attestationObject,
//               "transports": ["AUTHENTICATOR_TRANSPORT_HYBRID"]
//             }
//           }
//         ],
//         'userId': userId
//       }
//     };
//     DioRequest.createAuthenticators(requestBody,
//         userId: passkeyUserId, userName: passkeyUserName);
//   }
// }

void signTransaction({
  required String organizationId,
  required String walletAddress,
}) async {
  const userOpHash =
      '588e4e2885dc64d966c7bdaaf7ffeca3234132a7c292282ee5c64d2e8ae8a09f';
  // final payload = hashMessage(userOpHash);
  // print('payload ======= $payload');
  final requestBody = {
    'type': 'ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2',
    'timestampMs': DateTime.now().millisecondsSinceEpoch.toString(),
    'organizationId': organizationId,
    'parameters': {
      'signWith': walletAddress,
      'payload':
          '262ad9708933bd1fe077cb9628c1ed955a045d96dd196581f57c896c10ed6982',
      'encoding': 'PAYLOAD_ENCODING_HEXADECIMAL',
      'hashFunction': 'HASH_FUNCTION_NO_OP',
    }
  };
  DioRequest.signTransaction(
    requestBody,
  );
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
