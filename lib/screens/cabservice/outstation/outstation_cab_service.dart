// ignore_for_file: depend_on_referenced_packages

import 'package:figgocabs/controllers/outstation_cab_controller.dart';
import 'package:figgocabs/screens/cabservice/outstation/fetch_outstation_price_screen.dart';
import 'package:figgocabs/screens/common/select_location.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

class OutStationCabService extends StatefulWidget {
  const OutStationCabService({Key? key}) : super(key: key);

  @override
  State<OutStationCabService> createState() => _OutStationCabServiceState();
}

class _OutStationCabServiceState extends State<OutStationCabService>
    with SingleTickerProviderStateMixin {

  var controller = Get.put(OutstationCabController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 0),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            height: size.height / 2.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/outstation_bg.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            height: size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin:
                  EdgeInsets.only(top: (size.height / 3), left: 16, right: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  //set border radius more than 50% of height and width to make circle
                ),
                elevation: 10,
                color: Colors.white,
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Obx(() => Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.updateTripType();
                                },
                                child: Obx(() => Container(
                                  padding: const EdgeInsets.all(12.0),
                                  margin: const EdgeInsets.fromLTRB(
                                      12.0, 12.0, 6.0, 0.0),
                                  decoration: BoxDecoration(
                                      color: controller.isOneWay.value
                                          ? primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 8,
                                          color: Color.fromRGBO(0, 0, 0, 0.16),
                                        )
                                      ]),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'One Way',
                                    style: TextStyle(
                                        color: controller.isOneWay.value
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.updateTripType();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  margin: const EdgeInsets.fromLTRB(
                                      6.0, 12.0, 12.0, 0.0),
                                  decoration: BoxDecoration(
                                      color: controller.isOneWay.value
                                          ? Colors.white
                                          : primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 8,
                                          color: Color.fromRGBO(0, 0, 0, 0.16),
                                        )
                                      ]),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Round Trip',
                                    style: TextStyle(
                                        color: controller.isOneWay.value
                                            ? Colors.grey
                                            : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                        8.height,
                        Obx(() => buildTripDetailsWidget()),
                        Container(
                            height: 46,
                            width: double.infinity,
                            margin: const EdgeInsets.all(12),
                            child: ElevatedButton(
                              onPressed: () {
                                if(controller.distance.value != 0 && controller.startLatLng != null
                                    && controller.endLatLng != null && controller.pickupTimeController.text.isNotEmpty
                                && controller.pickupDateController.text.isNotEmpty){
                                  FetchOutstationPriceScreen(
                                    isReturn: !controller.isOneWay.value,
                                  ).launch(context,
                                      isNewTask: false,
                                      pageRouteAnimation:
                                      PageRouteAnimation.Fade);
                                }else{
                                  Get.showSnackbar(errorSnackBar(message: 'Fill details properly'));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: primaryColor,
                              ),
                              child: const Text(
                                'Get Best Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ))
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTripDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: controller.fromController,
              readOnly: true,
              onTap: () {
                _navigateAndFetchDeparture(context);
              },
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'From',
                  prefixIcon: Icon(Icons.my_location, color: Colors.grey)),
            ),
          ),
          12.height,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: controller.toController,
              readOnly: true,
              onTap: () {
                _navigateAndFetchDestination(context);
              },
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'To',
                  prefixIcon: Icon(Icons.location_on, color: Colors.grey)),
            ),
          ),
          12.height,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              readOnly: true,
              controller: controller.pickupDateController,
              onTap: () {
                _selectDate(context, controller.pickupDateController);
              },
              keyboardType: TextInputType.phone,
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select pickup date',
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.grey)),
            ),
          ),
          12.height,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              readOnly: true,
              controller: controller.pickupTimeController,
              onTap: () {
                _selectTime(context, controller.pickupTimeController);
              },
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select pickup time',
                  prefixIcon: Icon(Icons.watch_later, color: Colors.grey)),
            ),
          ),
          Visibility(
            visible: controller.isOneWay.value ? false : true,
            child: Column(
              children: [
                12.height,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.black)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    controller: controller.returnDateController,
                    onTap: () {
                      _selectDate(context, controller.returnDateController);
                    },
                    validator: (item) {
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Select return date',
                        prefixIcon:
                            Icon(Icons.calendar_month, color: Colors.grey)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAndFetchDeparture(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
    );

    if (!mounted) return;
      if (data != null) {
        controller.fromController.text = data.result.formattedAddress.toString();
        controller.startLatLng = LatLng(data.result.geometry!.location.lat,
            data.result.geometry!.location.lng);
        if(controller.startLatLng != null && controller.endLatLng != null){
          getExtraInfo();
        }
      }
  }

  Future<void> _navigateAndFetchDestination(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
    );

    if (!mounted) return;
      if (data != null) {
        controller.toController.text = data.result.formattedAddress.toString();
        controller.endLatLng = LatLng(data.result.geometry!.location.lat,
            data.result.geometry!.location.lng);
        if(controller.startLatLng != null && controller.endLatLng != null){
          getExtraInfo();
        }
      }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  Future<void> getExtraInfo() async {
    await controller
        .getDurationDistance(controller.startLatLng!,
        controller.endLatLng!)
        .then((durationValue) {
      setState(() {
        controller.distance.value =
            durationValue['rows'].first['elements'].first['distance']['value'] /
                1000.00;
        controller.duration.value =
        durationValue['rows'].first['elements'].first['duration']['text'];
      });

      if(controller.distance.value <= 40) {
        controller.disableButtons(true);
        Get.showSnackbar(defaultSnackBar(message: 'Use city cab if travel distance is lesser than 40KM'));
      }else{
        controller.disableButtons(false);
      }

    });
  }

}
