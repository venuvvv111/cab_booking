// ignore_for_file: unused_local_variable

import 'package:figgocabs/controllers/package_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

const normal = TextStyle(
  fontSize: 14,
);
const bold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {

  var packageController = Get.put(PackageController());

  @override
  void initState() {
    super.initState();
    packageController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Packages'),
        backgroundColor: const Color(0xFF233757),
        centerTitle: true,
      ),
      body: GetBuilder<PackageController>(
        builder: (controller) => controller.packageModel == null ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: primaryColor, size: 48),) :
        ListView.builder(
          itemCount: controller.packageModel!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Name: ',
                                ),
                                Text(
                                  controller.packageModel![index].name,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Price: ',
                                ),
                                Text(
                                  controller.packageModel![index].price.toString(),
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'From: ',
                                ),
                                Text(
                                  controller.packageModel![index].homeadd,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'To: ',
                                ),
                                Text(
                                  controller.packageModel![index].dest,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Vehicle: ',
                                ),
                                Text(
                                  controller.packageModel![index].vichle,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Duration: ',
                                ),
                                Text(
                                  controller.packageModel![index].vichle,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pickup Time: ',
                                ),
                                Text(
                                  controller.packageModel![index].pickupTime,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Drop Time: ',
                                ),
                                Text(
                                  controller.packageModel![index].offTime,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Package Name: ',
                                ),
                                Text(
                                  controller.packageModel![index].type,
                                  style: bold,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Alloted Driver: ',
                                ),
                                Text(
                                  controller.packageModel![index].allotedDriver,
                                  style: bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}