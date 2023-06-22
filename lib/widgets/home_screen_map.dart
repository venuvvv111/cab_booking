import 'dart:async';

import 'package:figgocabs/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenMap extends StatefulWidget {
  const HomeScreenMap({Key? key}) : super(key: key);

  @override
  State<HomeScreenMap> createState() => _HomeScreenMapState();
}

class _HomeScreenMapState extends State<HomeScreenMap> {

  final controller = Get.put(LocationController());

  final List<Marker> _markers = <Marker>[];
  String _mapStyle = "";


  GoogleMapController? mapController; //controller for Google map
  CameraPosition? cameraPosition;
  LatLng? initialPosition;
  String address = 'Fetching Location';

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          height: MediaQuery.of(context).size.height / 2.5,
          width: double.infinity,
          child: initialPosition == null ?
              Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey.shade300,
                child: Container(
                  color: Colors.grey,
                ),
              )
          : GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: initialPosition!,
              zoom: 18.0,
            ),
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(_markers),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
              controller.setMapStyle(_mapStyle);
            },
          ),
        ),
        Positioned(
          bottom: -24,
          right: 0,
          left: 0,
          child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            boxShadow: [
              BoxShadow(color: shadowColorGlobal, offset: const Offset(1, 0)),
              BoxShadow(color: shadowColorGlobal, offset: const Offset(0, 1)),
              BoxShadow(color: shadowColorGlobal, offset: const Offset(-1, 0)),
              BoxShadow(color: shadowColorGlobal, offset: const Offset(0, -1)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                address,
                style: secondaryTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).expand(),
              address == "Fetching Location" ? LoadingAnimationWidget.waveDots(color: Colors.grey, size: 18) : InkWell(onTap: (){
                setState(() {
                  address = 'Fetching Location';
                });
                init();
              }, child: const Icon(Icons.my_location, color: Colors.grey)),
            ],
          ),
        ),)
      ],
    );
  }

  Future<void> init() async {
    LatLng? currentPosition = await controller.getCurrentLatLng();
    address = await controller.getCurrentAddress();
    setState(() {
      initialPosition = currentPosition;
      _markers.add(Marker(markerId: const MarkerId('Current Position'), position: initialPosition! ));
    });
  }

}
