// ignore_for_file: unused_import

import 'package:figgocabs/screens/cabservice/cityCab/package/fetch_package_price_screen.dart';
import 'package:figgocabs/screens/cabservice/outstation/review_booking_screen.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/category_title.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PackageCabService extends StatefulWidget {
  const PackageCabService({Key? key}) : super(key: key);

  @override
  State<PackageCabService> createState() => _PackageCabServiceState();
}

class _PackageCabServiceState extends State<PackageCabService> {
  int selectedIndex = 0;
  List<String> hoursList = [
    "1hr",
    "2hr",
    "3hr",
    "4hr",
    "5hr",
    "6hr",
    "7hr",
    "8hr",
    "9hr",
    "10hr",
    "11hr",
    "12hr",
  ];

  List<String> kmsList = [
    "10km",
    "20km",
    "30km",
    "40km",
    "50km",
    "60km",
    "70km",
    "80km",
    "90km",
    "100km",
    "110km",
    "120km",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryTitle(title: 'Fill ride details'),
            buildTopSection(),
            const CategoryTitle(title: 'Select package'),
            buildKmSelector(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 46,
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              const FetchPackagePriceScreen(from: "Sector 43").launch(context,
                  isNewTask: false,
                  pageRouteAnimation: PageRouteAnimation.Fade);
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
          )),
    );
  }

  buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'From',
                  prefixIcon: Icon(Icons.my_location)),
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
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select pickup date',
                  prefixIcon: Icon(Icons.calendar_month)),
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
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select pickup time',
                  prefixIcon: Icon(Icons.watch_later)),
            ),
          ),
        ],
      ),
    );
  }

  buildKmSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 12.0, mainAxisSpacing: 12.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 12,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: selectedIndex == index ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hoursList[index],
                      style: primaryTextStyle(
                          size: 20,
                          color: selectedIndex == index
                              ? Colors.white
                              : primaryColor),
                    ),
                    4.height,
                    Text(
                      kmsList[index],
                      style: primaryTextStyle(
                          size: 14,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.grey),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
