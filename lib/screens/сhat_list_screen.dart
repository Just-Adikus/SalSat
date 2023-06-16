import 'package:flutter/material.dart';
import 'package:salsat_marketplace/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Здесь вы можете разместить код для отображения списка чатов
    // Используйте ListView.builder или другой подходящий виджет для отображения элементов списка чатов
    return ListView.builder(
      itemCount: 10, // Замените на фактическое количество чатов
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Chat $index'),
          onTap: () {
            // Обработка нажатия на элемент списка чатов
            // Переход на экран с чатом
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(userDetails: {'userName': 'User $index'})), // Передайте необходимые данные пользователя в параметре userDetails
            );
          },
        );
      },
    );
  }
}