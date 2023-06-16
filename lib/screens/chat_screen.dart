import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:salsat_marketplace/models/message.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? userDetails;

  ChatScreen({required this.userDetails});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _messagesCollection;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _messagesCollection = _firestore.collection('messages');
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      await _messagesCollection.add({
        'sender': widget.userDetails?['userName'],
        'content': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'userId':widget.userDetails?['userId']
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp != null && timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return formattedTime;
    } else {
      return '';
    }
  }

  Future<void> _sendPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(file);
        final downloadURL = await ref.getDownloadURL();
        await _sendMessage(downloadURL);
      } catch (e) {
        print('Error sending photo: $e');
      }
    }
  }

  Future<void> _sendVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
        await ref.putFile(file);
        final downloadURL = await ref.getDownloadURL();
        await _sendMessage(downloadURL);
      } catch (e) {
        print('Error sending video: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

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
        elevation: 0,
        title: ListTile(
        leading: Icon(Icons.person_outline_outlined,
        color: Colors.black,),
        title: Text('${widget.userDetails!['userName']}',
        style: TextStyle(color: Colors.black,
        fontWeight: FontWeight.w600),),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                          messages[index].data()! as Map<String, dynamic>;
                      final message = Message.fromMap(messageData);

                      if (message.content is String && message.content.startsWith('https:')) {
                        if (message.content.startsWith('https://firebasestorage.googleapis.com/v0/b/salsat-3de2d.appspot.com/o/photos%')) {
                          return ListTile(
                            title: Image.network(message.content),
                            subtitle: Text(
                              '${message.sender} • ${formatTimestamp(message.timestamp)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        } else if (message.content.startsWith('https://firebasestorage.googleapis.com/v0/b/salsat-3de2d.appspot.com/o/videos%')) {
                          return ListTile(
                            title: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: FutureBuilder(
                                future: _initializeVideoPlayer(message.content),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return VideoPlayer(_videoPlayerController!);
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                            subtitle: Text(
                              '${message.sender} • ${formatTimestamp(message.timestamp)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }
                      }

                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(
                          '${message.sender} • ${formatTimestamp(message.timestamp)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error retrieving messages');
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Жазу',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(
                    _messageController.text,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _sendPhoto,
                ),
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: _sendVideo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeVideoPlayer(String videoURL) async {
    _videoPlayerController = VideoPlayerController.network(videoURL);
    await _videoPlayerController!.initialize();
  }
}
