import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/models/message.dart';
import 'package:salsat_marketplace/screens/%D1%81hat_list_screen.dart';
import 'package:salsat_marketplace/screens/add_product_screen.dart';
import 'package:salsat_marketplace/screens/chat_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/product_detail_screen.dart';
import 'package:salsat_marketplace/screens/profile_screen.dart';
import 'package:salsat_marketplace/screens/user_product_screen.dart';
import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';

class AllChatsScreen extends StatefulWidget {
  
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
final DataController controller = Get.put(DataController());
late final Message message;
int _selectedIndex = 1;
void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

//   // Добавьте навигацию для перехода на соответствующую страницу
  switch (index) {
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AllChatsScreen()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProductScreen()));
      break;
    case 4:
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      break;
  }
}
// Future<Map<String, dynamic>> userDetails = controller.getUserNameById(widget.product.userId);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Чаттар',
            style: TextStyle(
              color: Colors.black
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black.withOpacity(0.5), 
            indicatorColor:Colors.black,
            tabs: [
              Tab(text: 'Барлығы'),
              Tab(text: 'Сатып алу'),
              Tab(text: 'Сату'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
          FutureBuilder<List<Message>>(
            future: controller.getMessages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return ListTile(
                        leading: Icon(Icons.person, color: Colors.black,),
                        title: Text(message.sender),  // отображаем имя отправителя
                        subtitle: Text(message.content),  // отображаем текст сообщения
                        onTap: () async{
                          Map<String, dynamic> userDetails =
                          await controller.getUserNameById(message.userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(userDetails:userDetails,),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Text('No messages found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder<List<Message>>(
            future: controller.getMessages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return ListTile(
                        leading: Icon(Icons.person, color: Colors.black,),
                        title: Text(message.sender),  // отображаем имя отправителя
                        subtitle: Text(message.content),  // отображаем текст сообщения
                        onTap: () async{
                          Map<String, dynamic> userDetails =
                          await controller.getUserNameById(message.userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(userDetails:userDetails,),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Text('No messages found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder<List<Message>>(
            future: controller.getMessages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return ListTile(
                        leading: Icon(Icons.person, color: Colors.black,),
                        title: Text(message.sender),  // отображаем имя отправителя
                        subtitle: Text(message.content),  // отображаем текст сообщения
                        onTap: () async{
                          Map<String, dynamic> userDetails =
                          await controller.getUserNameById(message.userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(userDetails:userDetails,),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Text('No messages found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

