import 'package:flutter/material.dart';

class HomeScreenServices extends StatefulWidget {
  final String image;
  final String title;
  const HomeScreenServices({super.key, required this.image, required this.title});

  @override
  State<HomeScreenServices> createState() => _HomeScreenServicesState();
}

class _HomeScreenServicesState extends State<HomeScreenServices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: Image(
              image: AssetImage(widget.image),
              fit: BoxFit.contain,
            ),
          ),
          Text(widget.title)
        ],
      ),
    );
  }
}