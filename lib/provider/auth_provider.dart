// lib/provider/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kisanseva/services/user_service.dart';

import '../screens/home_screen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String error = '';
  final UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      print(e.code);
    };

    final PhoneCodeSent smsOtpSent = (String verId, int? resendToken) async {
      verificationId = verId;
      smsOtpDialog(context, number);
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeAutoRetrievalTimeout: (String veriId) {
          verificationId = veriId;
        },
        codeSent: smsOtpSent,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Verification Code"),
              SizedBox(height: 6),
              Text(
                'Enter the 6-digit OTP received via SMS',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                smsOtp = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (verificationId != null && smsOtp != null) {
                    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                      verificationId: verificationId!,
                      smsCode: smsOtp!,
                    );

                    final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                    if (user != null) {
                      _createUser(id: user.uid, number: user.phoneNumber);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                    } else {
                      print("Login Failed");
                    }
                  } else {
                    print("Verification ID or SMS code is null");
                  }
                } catch (e) {
                  error = 'Invalid OTP';
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              },
              child: Text('DONE'),
            ),
          ],
        );
      },
    ).then((value) => false);
  }

  void _createUser({required String id, String? number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
    });
  }
}
