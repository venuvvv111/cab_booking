import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart' as conn;
import 'package:fbroadcast/fbroadcast.dart';
import 'package:figgocabs/controllers/location_controller.dart';
import 'package:figgocabs/screens/common/something_went_wrong_screen.dart';
import 'package:figgocabs/services/local_notification_service.dart';
import 'package:figgocabs/services/location_service.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import 'screens/common/no_connection_screen.dart';
import 'screens/common/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
bool isCurrentlyOnNoInternet = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }

  if (message.notification != null) {
    showLocalNotification(
      message.notification!.title!,
      message.notification!.body!,
    );
  }
}

FirebaseOptions options = const FirebaseOptions(
  appId: '1:613151874383:android:f72a0ade762ff05189f93a',
  apiKey: 'AIzaSyBXJlzc8N7oEaxJmqrFMPhdQBGTe8GQO_U',
  messagingSenderId: '613151874383',
  projectId: 'figgocabs-a9037',
);

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await setup();

  // open a screen whenever crash happens to make UX better
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return const SomethingWentWrongScreen();
  };

  /*//Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51MvYh9SJiWUgxxyLzvpYvaXM8uXI0hQYW4ovTZzybIcTK7JZcBNasJ9LA6sVBM4jw046sT4QCBWUdaj0Splaz5xD00NEpusvbc";
  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");*/
  Get.put(LocationController());
  // create an instance of LocationService
  final LocationService locationService = LocationService();
  // start listening to the location changes
  await locationService.startListening();

  await Firebase.initializeApp(
    options: options,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    if (message.notification != null) {
      showLocalNotification(
        message.notification!.title!,
        message.notification!.body!,
      );

      /// send broadcast
      FBroadcast.instance().broadcast(
        Constant.rideBroadcast,
        value: message.notification!.body!
      );


    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<conn.ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    connectivitySubscription.cancel();
  }

  void init() async {
    connectivitySubscription =
        conn.Connectivity().onConnectivityChanged.listen((e) {
      if (e == conn.ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        const NoConnectionScreen().launch(
            navigatorKey.currentState!.overlay!.context,
            isNewTask: false,
            pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        if (isCurrentlyOnNoInternet) {
          Navigator.pop(navigatorKey.currentState!.overlay!.context);
          isCurrentlyOnNoInternet = false;
          toast('Internet is connected.');
        }
        log('connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Figgo Cabs',
      home: const SplashScreen(),
    );
  }
}
