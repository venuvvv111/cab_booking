import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ItemPlaceWidget extends StatelessWidget {
  final String text;

  const ItemPlaceWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          12.width,
          Expanded(child: Text(text, style: primaryTextStyle(),))
        ],
      ),
    );
  }
}
