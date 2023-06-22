// ignore_for_file: unused_import, avoid_unnecessary_containers

import 'package:figgocabs/screens/cabservice/cityCab/booked_cab_screen.dart';
import 'package:figgocabs/screens/homescreen/ride_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:figgocabs/controllers/ride_history_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../utility/app_theme.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final box = GetStorage();
  final RideHistoryController controller = Get.put(RideHistoryController());

  @override
  void initState() {
    super.initState();
    controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.height,
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text('Ride history', style: boldTextStyle(size: 32)),
            ),
            Obx(() => controller.isFetching.value
                ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            color: primaryColor, size: 48))
                    .expand()
                : controller.rideHistoryModel != null
                    ? controller.rideHistoryModel!.data.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                controller.rideHistoryModel!.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return rideCard(index);
                            }).expand()
                        : noData()
                    : noData())
          ],
        ),
      ),
    );
  }

  Widget rideCard(int index) {
    return GestureDetector(
      onTap: () {
        RideDetails(bookingID: controller.rideHistoryModel!.data[index].bookingId,).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: Container(
        margin: index == 0 ? const EdgeInsets.all(16) : const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Booking id : ${controller.rideHistoryModel!.data[index].bookingId}', style: boldTextStyle(color: primaryColor),),
                if (controller.rideHistoryModel!.data[index].status != "4" && controller.rideHistoryModel!.data[index].status != "10")
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: (){
                      BookedCabScreen(
                        isHistory: true,
                        bookingID: controller.rideHistoryModel!.data[index].bookingId,
                      ).launch(context,
                          isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
                    }, child: const Text('Track'))
              ],
            ),
            const Divider(),
            8.height,
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_pic_drop_location.png',
                      height: 70,
                    ),
                    12.width,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.rideHistoryModel!.data[index].fromnameLocation,
                              maxLines: 1,
                              style: primaryTextStyle(size: 18),),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                            Text(controller.rideHistoryModel!.data[index].tonameLocation,
                              maxLines: 1,
                              style: primaryTextStyle(size: 18),),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ ${controller.rideHistoryModel!.data[index].amount}', style: boldTextStyle(size: 20),),
                controller.rideHistoryModel!.data[index].status == "10" ?
                Text('Cancelled', style: primaryTextStyle(size: 20, color: Colors.red),) :
                controller.rideHistoryModel!.data[index].status == "4" ?
                Text('Completed', style: primaryTextStyle(size: 20, color: Colors.green),) :
                Text('Confirmed', style: primaryTextStyle(size: 20, color: Colors.grey),)
              ],
            )
          ],
        ),
      ),
    );
  }

  noData() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_data.png',
            scale: 4,
          ),
          12.height,
          Text(
            'No rides found',
            style: primaryTextStyle(size: 18),
          )
        ],
      ),
    ).expand();
  }
}
