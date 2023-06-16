import 'package:flutter/material.dart';
import 'package:salsat_marketplace/controllers/auth_controller.dart';

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({Key? key}) : super(key: key);

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  final authController = AuthController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
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
            "Тіркелу",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    child: Image.asset('assets/images/user.png'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Эл.поштаны және құпиясөзді енгізіңіз",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person_outlined,color: Colors.black,),
                    labelText: "Аты-жөніңізді енгізіңіз",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.email_outlined,color: Colors.black,),
                    labelText: "Эл.поштаны еңгізіңіз",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: false,
                  controller: mobileController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.flag,color: Colors.black,),
                    labelText: "Телефон нөмірін еңгізіңіз",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: pwdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.key,color: Colors.black,),
                    labelText: "Құпиясөзді еңгізіңіз",
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                  authController.signUp(
                    emailController.text,
                    pwdController.text,
                    usernameController.text,
                    mobileController.text
                  );
                  },
                  child: Text("Тіркеу",
                  style: TextStyle(
                  fontSize: 20
                  ),),
                ),
                ],
                ),
              ],
            ),
          ),
        ));
  }
}
