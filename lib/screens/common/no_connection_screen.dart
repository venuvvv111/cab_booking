import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  NoConnectionScreenState createState() => NoConnectionScreenState();
}

class NoConnectionScreenState extends State<NoConnectionScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/connectionLost.png', fit: BoxFit.cover, height: context.height()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('No Connection', style: boldTextStyle(size: 30)),
              32.height,
              Text(
                'Please connect to internet and then try again.'  ,
                style: primaryTextStyle(color: Colors.blueGrey, size: 18),
              ),
              48.height,
            ],
          ).paddingAll(32),
        ],
      ),
    );
  }
}
