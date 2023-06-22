import 'package:figgocabs/controllers/payment_controller.dart';
import 'package:figgocabs/models/accept_driver_model.dart';
import 'package:figgocabs/screens/cabservice/cityCab/booked_cab_screen.dart';
import 'package:figgocabs/screens/homescreen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentStatusScreen extends StatefulWidget {
  final String amount;
  final bool isSuccess;
  final String paymentMethod;
  final String pickupDate;
  final String pickupTime;
  final String failureReason;
  final String transactionID;

  final AcceptDriverModel? acceptDriverModel;
  const PaymentStatusScreen({Key? key, required this.amount, required this.isSuccess, this.acceptDriverModel,
    required this.paymentMethod, required this.pickupDate, required this.pickupTime, required this.failureReason, required this.transactionID}) : super(key: key);

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {

  final controller = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    if(widget.paymentMethod == "wallet"){
      controller.payViaWallet(widget.amount, widget.pickupDate, widget.pickupTime, widget.acceptDriverModel!, context);
    }else{
      if(widget.isSuccess){
        Future.delayed(const Duration(seconds: 3)).then((value) {
          controller.processing(false);
          controller.success(true);
          Future.delayed(const Duration(seconds: 3)).then((value) {
            BookedCabScreen(pickupDate: widget.pickupDate, pickupTime: widget.pickupTime, paymentMode: "wallet",
              acceptDriverModel: widget.acceptDriverModel, isHistory: false, transactionID: widget.transactionID,)
                .launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          });
        });
      }else{
        Future.delayed(const Duration(seconds: 3)).then((value) {
          controller.processing(false);
          controller.failed(true);
          Future.delayed(const Duration(seconds: 3)).then((value) {
            Get.offAll(DashboardScreen());
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.processing.value ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/rupee.json'),
        ],
      ) : controller.success.value ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/successful.json'),
          Text('Payment of Rs ${widget.amount} is successful to Figgo',
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 22),),
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/failed.json'),
          Text('Payment of Rs ${widget.amount} is successful to Figgo',
              textAlign: TextAlign.center,
              style: primaryTextStyle()),
        ],
      )),
    );
  }
}
