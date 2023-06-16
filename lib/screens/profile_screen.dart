import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salsat_marketplace/controllers/auth_controller.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/screens/add_product_screen.dart';
import 'package:salsat_marketplace/screens/all_chats_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/transaction_screen.dart';
import 'package:salsat_marketplace/screens/user_product_screen.dart';
import 'package:salsat_marketplace/screens/welcome_screen.dart';
import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataController controller = Get.put(DataController());
  final AuthController authController = Get.find();
  String userName = "";
  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AllChatsScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddProductScreen()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProductScreen()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.getUserProfileData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 45,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/user.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.userProfileData['userName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Профильді өңдеу",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            )
                          ],
                        )
                      ],
                    )
                  ]),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.credit_card_outlined,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Транзакциялар",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )),
                onTap: () async {
                Navigator.push(context,
                MaterialPageRoute(
                builder: (context) => TransactionScreen(),
                ),
                );

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
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.settings_outlined,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Параметрлер",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )),
                onTap: () {},
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
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.help_outline,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Көмек",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )),
                onTap: () {
                  _showHelpDialog();
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
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Шығу",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      if (user.providerData.any(
                          (userInfo) => userInfo.providerId == 'google.com')) {
                        // Вход выполнен через Google
                        final googleSignIn = GoogleSignIn();
                        await authController.signOutGoogle();
                      } else {
                        // Вход выполнен другим методом
                        await FirebaseAuth.instance.signOut();
                      }

                      // Добавление задержки
                      await Future.delayed(Duration(seconds: 1));
                    }

                    Get.offAll(
                        WelcomeScreen()); // Замените на виджет экрана входа в систему
                  },

              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _showHelpDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Көмек'),
        content: Text(
          'Егер де бір ақау орын алған жағдайда, әлде қандай да бір көмек қажет болған жағдайда мына пошта арықылы хабарласыңыз salsatgroup@gmail.com',
        ),
        actions: [
          TextButton(
            child: Text('Жабу'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
