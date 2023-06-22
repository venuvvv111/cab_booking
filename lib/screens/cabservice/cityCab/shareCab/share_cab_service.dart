import 'package:figgocabs/screens/cabservice/cityCab/shareCab/fetch_share_cabs.dart';
import 'package:figgocabs/screens/common/select_location.dart';
import 'package:figgocabs/utility/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ShareCabService extends StatefulWidget {
  const ShareCabService({Key? key}) : super(key: key);

  @override
  State<ShareCabService> createState() => _ShareCabServiceState();
}

class _ShareCabServiceState extends State<ShareCabService>
    with SingleTickerProviderStateMixin {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: size.height / 2.5,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/share_bg.png'),
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
            Container(
              margin:
                  EdgeInsets.only(top: (size.height / 6), left: 16, right: 16),
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
                        buildInfoWidget(),
                        Container(
                          height: 46,
                          width: double.infinity,
                          margin: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () {
                              FetchShareCabs(
                                destination: toController.text,
                                from: fromController.text,
                              ).launch(context,
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
                              'Current',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                            height: 46,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: ElevatedButton(
                              onPressed: () {
                                FetchShareCabs(
                                  destination: toController.text,
                                  from: fromController.text,
                                ).launch(context,
                                    isNewTask: false,
                                    pageRouteAnimation:
                                        PageRouteAnimation.Fade);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: primaryColor,
                              ),
                              child: const Text(
                                'Advance',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ))
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              readOnly: true,
              controller: fromController,
              onTap: () {
                _navigateAndFetchLocation(context, fromController);
              },
              validator: (item) {
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'From',
                  prefixIcon: Icon(
                    Icons.my_location,
                    color: Colors.grey,
                  )),
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
              controller: toController,
              onTap: () {
                _navigateAndFetchLocation(context, toController);
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
          Row(
            children: [
              4.width,
              Icon(
                Icons.info,
                color: Colors.grey.shade500,
              ),
              8.width,
              Flexible(
                  child: Text(
                'Kids below 5 year not required for booking.',
                style: secondaryTextStyle(size: 14),
              )),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _navigateAndFetchLocation(
      BuildContext context, TextEditingController controller) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
    );

    if (!mounted) return;
    setState(() {
      if (data != null) {
        controller.text = data.result.formattedAddress.toString();
      }
    });
  }
}
