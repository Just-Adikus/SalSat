
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salsat_marketplace/screens/email_login_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>_EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  IconData iconToShow = Icons.warning;
  String textToShow = "Электронды поштаны растаңыз";

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    await user!.reload();
    if (user!.emailVerified) {
      setState(() {
        isEmailVerified = true;
        iconToShow = Icons.check_circle;
        textToShow = "Электронды пошта расталған";
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor:Colors.white,
      leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_new_outlined,
      color: Colors.black,),
      onPressed: () {
              Navigator.pop(context);
            },
          ),
      title: Text("Поштаны растау",
      style: TextStyle(color: Colors.black),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              
              iconToShow,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              textToShow,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) => EmailLoginScreen()));
                  },
                  child: Text("Кіру",
                  style: TextStyle(
                  fontSize: 20
                  ),),
                ),
          ],
        ),
      ),
    );
  }
}

