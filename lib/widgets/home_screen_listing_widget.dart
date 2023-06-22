// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomeScreenListingWidget extends StatefulWidget {
  final String title;
  final String image;
  final String subtitle;
  const HomeScreenListingWidget({super.key, required this.title, required this.image, required this.subtitle});

  @override
  State<HomeScreenListingWidget> createState() => _HomeScreenListingWidgetState();
}

class _HomeScreenListingWidgetState extends State<HomeScreenListingWidget> {

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: Image(
            image: AssetImage(widget.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}