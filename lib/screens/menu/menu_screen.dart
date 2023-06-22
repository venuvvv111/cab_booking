import 'package:cool_alert/cool_alert.dart';
import 'package:figgocabs/screens/menu/profile_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/utility/general_fucntions.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              12.height,
              Text('More', style: boldTextStyle(size: 32)),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor,
                      child: ClipOval(
                        child: box.read(Constant.profilePic) != null
                            ? Image.network(
                                box.read(Constant.profilePic),
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              )
                            : const Icon(Icons.account_circle, size: 80),
                      ),
                    ),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(box.read(Constant.name),
                            style: boldTextStyle(size: 18)),
                        4.height,
                        Text(box.read(Constant.mobile),
                            style: primaryTextStyle(
                                color: const Color(0xFF747474))),
                      ],
                    ).expand(),
                    GestureDetector(
                        onTap: () {
                          const ProfileScreen().launch(context,
                              isNewTask: false,
                              pageRouteAnimation: PageRouteAnimation.Fade);
                        },
                        child: const Icon(Icons.edit))
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    10.height,
                    listItem(Icons.local_offer_rounded, 'Offers'),
                    listItem(Icons.attach_money, 'Refer & Earn'),
                    listItem(Icons.handshake, 'Join as partner'),
                    10.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    10.height,
                    listItem(Icons.question_mark, 'Terms & Conditions'),
                    listItem(Icons.feedback, 'Feedback'),
                    listItem(Icons.call, 'Customer Support'),
                    listItem(Icons.star, 'Rate us').onTap(() {
                      // open play store to rate the app
                    }),
                    8.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  children: <Widget>[
                    listItem(Icons.logout, "Logout").onTap(() {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        confirmBtnColor: primaryColor,
                        onConfirmBtnTap: (){
                          signout();
                        },
                        text: "Do you want to logout",
                        confirmBtnText: "Yes",
                        cancelBtnText: "No",
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(IconData icon, String heading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon,
                  color: heading == "Logout" ? Colors.red : Colors.black),
              16.width,
              Text(
                heading,
                style: primaryTextStyle(
                    color: heading == "Logout" ? Colors.red : Colors.black),
              ),
            ],
          ).expand(),
          Icon(Icons.keyboard_arrow_right,
              color:
                  heading == "Logout" ? Colors.red : const Color(0xFF747474)),
        ],
      ),
    );
  }
}
