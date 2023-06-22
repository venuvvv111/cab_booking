// ignore_for_file: use_build_context_synchronously

import 'package:figgocabs/controllers/location_controller.dart';
import 'package:figgocabs/screens/common/location_picker_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/item_places.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final controller = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    controller.placesList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Text(
                'Select location',
                style: boldTextStyle(size: 24),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xffececec)),
              child: TextFormField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.pin_drop,
                    color: Color(0xff484848),
                  ),
                  hintText: 'Enter location',
                  hintStyle: primaryTextStyle(),
                ),
                onChanged: (value) {
                  controller.placeSelectAPI(value);
                },
                cursorColor: blackColor,
                keyboardType: TextInputType.text,
              ),
            ),
            GestureDetector(
              onTap: () {
                _navigateAndDisplaySelection(context);
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_history,
                      color: Colors.white,
                    ),
                    12.width,
                    Text(
                      'Pick from map',
                      style: primaryTextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Results',
                    style: boldTextStyle(size: 18),
                  ),
                  12.height,
                  Obx(() => controller.placesList.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.placesList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () async {
                                  var result =
                                      await controller.displayPrediction(
                                          controller.placesList[index]);
                                  Navigator.pop(context, result);
                                },
                                child: ItemPlaceWidget(
                                    text: controller
                                        .placesList[index].description!));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        )
                      : Container())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (!mounted) return;
    setState(() {
      if (data != null) {
        Navigator.pop(context, data);
      } else {
        if (kDebugMode) {
          print('Data is null');
        }
      }
    });
  }
}
