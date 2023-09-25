

import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeModule extends StatelessWidget {
  final imageConstant = ImagesConstant();

  final imagePaths = [
    'assets/images/1.PNG',
    'assets/images/2.PNG',
    'assets/images/3.PNG'
  ];

  HomeModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/images/attendance.png'),
                iconSize: 80,
                onPressed: () {},
              ),
              const Text(
                "Working \nSchedules",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/images/classes.png'),
                iconSize: 80,
                onPressed: () {},
              ),
              const Text(
                "Teaching \n Records",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/images/booking.png'),
                iconSize: 80,
                onPressed: () {},
              ),
              const Text(
                "\nBooking",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/images/important-info.png'),
                iconSize: 80,
                onPressed: () {},
              ),
              const Text(
                "Public \nHoliday",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(
        height: 40,
      ),
      const Padding(
        padding: EdgeInsets.only(right: 190, bottom: 20, top: 50),
        child: Text(
          'Others TBS Platform ',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
        ),
      ),
      SizedBox(
          height: 220,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  height: 190,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  autoPlayInterval: const Duration(seconds: 2)),
              items: imagePaths.map((imagePath) {
                return Builder(builder: (context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(imagePath),
                  );
                });
              }).toList(),
            ),
          ])),
      const SizedBox(
        height: 30,
      ),
    ]);
  }
}
