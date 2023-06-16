import 'package:flutter/material.dart';
import 'package:carousel_images/carousel_images.dart';


final List<String> listImages = [
  'assets/slider/img1.jpg',
  'assets/slider/img2.jpg',
  'assets/slider/img3.jpeg',
  'assets/slider/img4.jpg',
  'assets/slider/img5.jpg',
  ];

Widget image_carousel = new Container(
  child: Padding (
  padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
  child:  CarouselImages(
        scaleFactor: 0.6,
        listImages: listImages,
        height: 250.0,
        borderRadius: 30.0,
        cachedNetworkImage: true,
        verticalAlignment: Alignment.topCenter,
        onTap: (index){
          print('Tapped on page $index');
        },
      )
  
  )

);
