import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/auth_controller.dart';
import 'package:salsat_marketplace/screens/email_login_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/phone_login_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class WelcomeScreen extends StatelessWidget {
  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    "SalSat",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    "SalSat-қа қош келдіңіз",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Expanded(
                  child: Center(
                    child: Text(
                      "Сатушыларға да, сатып алушыларға да ыңғайлы қосымша",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  InkWell(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: Center(
                            child: ListTile(
                              leading: Image.asset("assets/icons/google.png",
                                  height: 27),
                              title: Text(
                                "Google арқылы кіру",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                    onTap: () async {
                          User? user = await controller.signInWithGoogle();
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          } else {
                            showPlatformDialog(
                              context: context,
                              builder: (_) => BasicDialogAlert(
                                title: Text("Ошибка"),
                                content: Text("Не удалось выполнить вход через Google."),
                                actions: <Widget>[
                                  BasicDialogAction(
                                    title: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },

                  ),
                  SizedBox(
                    height: 1,
                  ),
                  InkWell(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.email_outlined,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Эл.пошта арқылы кіру",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmailLoginScreen()));
                    },
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  InkWell(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.phone_iphone_outlined,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Телефон нөмірі арқылы кіру",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhoneLoginScreen()));
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
