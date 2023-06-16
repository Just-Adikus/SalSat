import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildItem(
            image: "assets/categories/ct1.jpg",
            title: "Телефондар мен гаджеттер",
          ),
          buildItem(
            image: "assets/categories/ct2.jpg",
            title: "Компьютерлер",
          ),
          buildItem(
            image: "assets/categories/ct3.jpg",
            title: "Балалар тауарлары",
          ),
          buildItem(
            image: "assets/categories/ct10.png",
            title: "Косметика",
          ),
          buildItem(
            image: "assets/categories/ct5.jpg",
            title: "Тұрмыстық техника",
          ),
          buildItem(
            image: "assets/categories/ct11.png",
            title: "Аксессуарлар",
          ),
          buildItem(
            image: "assets/categories/ct7.jpg",
            title: "Киім",
          ),
          buildItem(
            image: "assets/categories/ct8.jpg",
            title: "Аяқ киім",
          ),
          buildItem(
            image: "assets/categories/ct91.jpg",
            title: "Жиһаз",
          ),
          buildItem(
            image: "assets/categories/ct6.jpg",
            title: "Авто",
          ),
          buildItem(
            image: "assets/categories/ct12.jpg",
            title: "Кеңсе тауарлары",
          ),
          buildItem(
            image: "assets/categories/ct13.jpg",
            title: "Тұрмыстық тауарлар",
          ),
        ],
      ),
    );
  }


  Widget buildItem({
    required String image,
    required String title,
    Color backgroundColor = Colors.black54,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: 150,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Обработчик нажатия на элемент
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity, // Задайте ширину на всю ширину контейнера
                  color: backgroundColor,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

