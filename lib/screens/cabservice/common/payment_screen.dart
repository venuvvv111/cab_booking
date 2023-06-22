// ignore_for_file: file_names

import 'dart:convert';

import 'package:figgocabs/models/accept_driver_model.dart';
import 'package:figgocabs/screens/cabservice/common/payment_status_screen.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final bool isAdvance;
  final String amount;
  final AcceptDriverModel? acceptDriverModel;
  final String pickupDate;
  final String pickupTime;

  const PaymentScreen({super.key, required this.isAdvance, required this.amount, this.acceptDriverModel, required this.pickupDate, required this.pickupTime});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  List<String> paymentMethods = ["Figgo wallet", "UPI", "Net Banking"];
  final box = GetStorage();

  List<String> paymentSubtitles = [
    "Free & Fast",
    "Gateway charge free",
    "2% gateway fees"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    100.height,
                    Center(
                      child: Text(
                        '₹ ${widget.amount}',
                        style: boldTextStyle(size: 36),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Extra fare will be charged if the journey is above 25.2 km as per Figgo policy.',
                        textAlign: TextAlign.center,
                        style: primaryTextStyle(size: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                buildArrivingCard(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select payment method',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    12.height,
                    buildPaymentOptions(),
                    8.height,
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ),
                    16.height
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget buildPaymentOptions() {
    return ListView(
        shrinkWrap: true,
    children: [
      ListTile(
        leading: const Icon(Icons.wallet),
        title: Text(paymentMethods[0]),
        subtitle: Text(paymentSubtitles[0]),
        trailing: ElevatedButton(
            onPressed: () async {
              PaymentStatusScreen(amount: widget.amount, isSuccess: true, acceptDriverModel: widget.acceptDriverModel, paymentMethod: 'wallet', pickupDate: widget.pickupDate, pickupTime: widget.pickupTime, failureReason: '', transactionID: '',).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
            },
            child: const Text('Pay now',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      ListTile(
        leading: const Icon(Icons.wallet),
        title: Text(paymentMethods[1]),
        subtitle: Text(paymentSubtitles[1]),
        trailing: ElevatedButton(
            onPressed: () async {
              toast('Not implemented yet');
            },
            child: const Text('Pay now',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      ListTile(
        leading: const Icon(Icons.wallet),
        title: Text(paymentMethods[2]),
        subtitle: Text(paymentSubtitles[2]),
        trailing: ElevatedButton(
            onPressed: () async {
              // Stripe
              // makePayment();

              // Razorpay
              Razorpay razorpay = Razorpay();
              var options = {
                'key': 'rzp_test_WtXtpOEbjrhOuC',
                'amount': 100,
                'name': 'Figgo Innovations',
                'description': 'Ride booking ',
                'currency': 'INR',
                'retry': {'enabled': true, 'max_count': 1},
                'send_sms_hash': true,
                'prefill': {'contact': box.read(Constant.mobile)},
                'external': {
                  'wallets': ['paytm']
                }
              };
              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
              razorpay.open(options);
            },
            child: const Text('Pay now',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      )
    ],);
  }

  buildArrivingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 58, 47, 47).withOpacity(0.6),
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 2.0, //extend the shadow
              offset: const Offset(
                5.0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: const Text(
              'Arriving time  9:25 AM',
              style: TextStyle(color: Colors.white),
            ),
          ),
          10.height,
          const Text(
              'Waiting charges are applicable only after 5 minutes of the driver reaching your pickup location as per Figgo Policy. ')
        ],
      ),
    );
  }

  /*Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentStatusScreen(amount: widget.amount,)),
    );

    if (!mounted) return;
    if (widget.isAdvance){
      const CongratulationScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }else{
      Navigator.pop(context, result);
    }
  }*/

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(widget.amount, 'INR');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  billingDetails: BillingDetails(
                      name: box.read(Constant.name),
                      phone: box.read(Constant.mobile),
                      address: const Address(
                          city: '',
                          country: 'IN',
                          line1: '',
                          line2: '',
                          postalCode: '',
                          state: '')),
                  customFlow: true,
                  merchantDisplayName: 'Figgo Innovations'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        toast('payment successful');
        PaymentStatusScreen(amount: widget.amount, isSuccess: true, acceptDriverModel: widget.acceptDriverModel, paymentMethod: 'stripe', pickupDate: widget.pickupDate, pickupTime: widget.pickupTime, failureReason: '', transactionID: '',).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        toast(stackTrace.toString());
        // PaymentStatusScreen(amount: widget.amount, isSuccess: false, paymentMethod: '', pickupDate: '', pickupTime: '',).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      });
    } on StripeException catch (e) {
      debugPrint('Error is:---> $e');
      PaymentStatusScreen(amount: widget.amount, isSuccess: false, paymentMethod: '', pickupDate: '', pickupTime: '', failureReason: '', transactionID: '',).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    } catch (e) {
      debugPrint('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    PaymentStatusScreen(amount: widget.amount, isSuccess: true, acceptDriverModel: widget.acceptDriverModel, paymentMethod: 'stripe', pickupDate: widget.pickupDate,
      pickupTime: widget.pickupTime, failureReason: '', transactionID: response.paymentId!,).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    debugPrint('External wallet selected');
  }
}
