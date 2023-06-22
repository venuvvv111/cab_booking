// ignore_for_file: depend_on_referenced_packages

import 'package:figgocabs/screens/cabservice/cityCab/anywhere/current_booking_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/utility/constant.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class AdvanceDateTimePicker extends StatefulWidget {
  final String bookingType;
  final String startAddress;
  final String destAddress;
  final String distance;
  final List<String> vehicleType;

  const AdvanceDateTimePicker({Key? key, required this.bookingType, required this.startAddress, required this.destAddress, required this.distance, required this.vehicleType}) : super(key: key);

  @override
  State<AdvanceDateTimePicker> createState() => _AdvanceDateTimePickerState();
}

class _AdvanceDateTimePickerState extends State<AdvanceDateTimePicker> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: noTitleAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Pick a date & time', style: boldTextStyle(size: 28)),
            ),
            32.height,
            TextFormField(
              controller: dateController,
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: inputDecoration(context,
                  hintText: "Pick date", prefixIcon: Icons.date_range_outlined),
            ),
            12.height,
            TextFormField(
              controller: timeController,
              readOnly: true,
              onTap: () {
                _selectTime(context);
              },
              decoration: inputDecoration(context,
                  hintText: "Pick time", prefixIcon: Icons.watch_later_rounded),
            ),
            32.height,
            Container(
                height: 46,
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.bookingType == Constant.cityRide){
                      CurrentBookingScreen(
                        startAddress: widget.startAddress,
                        destAddress: widget.destAddress,
                        distance: widget.distance,
                        vehicleTypes: widget.vehicleType,
                        pickupDate: dateController.text,
                        pickupTime: timeController.text,
                      ).launch(context,
                          isNewTask: false,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    backgroundColor: primaryColor,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
