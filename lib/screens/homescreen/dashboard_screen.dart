// ignore_for_file: use_build_context_synchronously

import 'package:figgocabs/controllers/dashboard_controller.dart';
import 'package:figgocabs/screens/homescreen/home_screen.dart';
import 'package:figgocabs/screens/homescreen/booking_history_screen.dart';
import 'package:figgocabs/screens/menu/menu_screen.dart';
import 'package:figgocabs/screens/wallet/wallet_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<DashboardController>(
        init: dashboardController,
        builder: (_) => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _.pageController,
          children: const [
            HomeScreen(),
            BookingHistoryScreen(),
            WalletScreen(),
            MenuScreen(),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<DashboardController>(
        init: dashboardController,
        builder: (_) => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: shadowColorGlobal,
                  offset: const Offset(0, -1),
                  blurRadius: 8,
              spreadRadius: 8),
            ],
          ),
          child: SlidingClippedNavBar(
            backgroundColor: Colors.white,
            onButtonPressed: _.onButtonPressed,
            iconSize: 30,
            activeColor: primaryColor,
            selectedIndex: _.selectedIndex.value,
            barItems: [
              BarItem(
                icon: Icons.home,
                title: 'Home',
              ),
              BarItem(
                icon: Icons.car_repair,
                title: 'Bookings',
              ),
              BarItem(
                icon: Icons.account_balance_wallet,
                title: 'My Wallet',
              ),
              BarItem(
                icon: Icons.menu,
                title: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

}
