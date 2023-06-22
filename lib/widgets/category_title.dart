import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryTitle extends StatefulWidget {
  final String title;
  const CategoryTitle({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryTitle> createState() => _CategoryTitleState();
}

class _CategoryTitleState extends State<CategoryTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Text(
        widget.title,
        style: boldTextStyle(size: 16),
      ),
    );
  }
}
