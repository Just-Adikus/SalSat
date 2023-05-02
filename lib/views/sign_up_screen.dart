// import 'package:sal_sat/generated/locale_keys.g.dart';

import '/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userSignupData = {
    "username": "",
    "email": "",
    "password": ""
  };

  AuthController controller = Get.find();

  signUp() {
    if (_formKey.currentState!.validate()) {
      print("Form is valid ");
      _formKey.currentState!.save();
      print('User Sign Up Data $userSignupData');
      controller.singUp(userSignupData['email'], userSignupData['password'],
          userSignupData['username']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('SignUp_Screen'.tr),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child:Image.asset('assets/images/shop.png')
                    // Image.network(
                    //   'https://cdn.pixabay.com/photo/2017/05/15/13/56/sign-up-2314914_1280.png',
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: ('User_Name'.tr),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'User_Name_Required'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['username'] = value!;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email'.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email_Required'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'.tr),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password_Required'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['password'] = value!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: signUp,
                    child: Text('Submit'.tr),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
