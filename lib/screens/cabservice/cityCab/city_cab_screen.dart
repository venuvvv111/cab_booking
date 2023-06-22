// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'package:figgocabs/screens/cabservice/cityCab/package/package_cab_service.dart';
import 'package:figgocabs/screens/cabservice/cityCab/shareCab/share_cab_service.dart';
import 'package:figgocabs/screens/common/location_access_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'anywhere/anywhere_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class CityCabScreen extends StatefulWidget {
  const CityCabScreen({super.key});

  @override
  _CityCabScreenState createState() => _CityCabScreenState();
}

class _CityCabScreenState extends State<CityCabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'City-Cab',
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: 'Anywhere',
            ),
            Tab(
              text: 'Share',
            ),
            Tab(
              text: 'Package',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: const [
                  AnywhereScreen(),
                  ShareCabService(),
                  PackageCabService(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      if (kDebugMode) {
        print('done');
      }
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      LocationAcessScreen().launch(context,
          isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
    }
  }
}
