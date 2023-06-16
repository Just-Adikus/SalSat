import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salsat_marketplace/controllers/comman_dailog.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/widgets/verification_code_field.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerificationCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Растау",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Растау кодын енгізіңіз",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Көрсетілген нөмірге жіберілген 6 таңбалы растау кодын енгізіңіз",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              VerificationCodeField(
                length: 6,
                onChanged: (String code) {
                  codeController.text = code;
                },
              ),
              SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      try {
                        CommanDialog.showLoading();
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: codeController.text.trim(),
                        );
                        await FirebaseAuth.instance.signInWithCredential(credential);
                        CommanDialog.hideLoading();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ));
                      } catch (e) {
                        CommanDialog.hideLoading();
                        print('Error occurred while signing in: $e');
                      }
                    },
                    child: Text(
                      "Келесі",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

