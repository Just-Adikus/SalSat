import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:salsat_marketplace/screens/profile_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {
           Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
        ),
        title: Text(
          'Транзакциялар',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: 
ListView(
  children: [
    ListTile(
      leading: Icon(
        Icons.photo,
        color: Colors.red,
      ),
      title: Text('checkout_1'),
    ),
    ListTile(
      leading: Icon(
         Icons.photo,
        color: Colors.red,
      ),
      title: Text('checkout_2'),
    ),
  ],
)
        
      
    );
  }
}

