import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MissingArticleScreen extends StatefulWidget {
  const MissingArticleScreen({Key? key}) : super(key: key);

  @override
  MissingArticleScreenState createState() => MissingArticleScreenState();
}

class MissingArticleScreenState extends State<MissingArticleScreen> {
  @override
  void initState() {
    setStatusBarColor(const Color(0xFFFFFFFF));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/article_missing.png', fit: BoxFit.cover, height: context.height()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Missing Service', style: boldTextStyle(size: 30)),
                16.height,
                Text(
                  'Service you are looking for is not available yet, But it will be here soon. Please check again later',
                  style: primaryTextStyle(size: 18, color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ).paddingSymmetric(vertical: 8, horizontal: 40),
                32.height,
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
                  elevation: 10,
                  color: primaryColor,
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go back', style: boldTextStyle(color: white)).paddingSymmetric(horizontal: 32),
                ),
                100.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
