// ignore_for_file: depend_on_referenced_packages

import 'package:figgocabs/controllers/location_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final controller = Get.put(LocationController());
  GoogleMapController? mapController; //controller for Google map
  CameraPosition? cameraPosition;
  LatLng? initialPosition;
  String location = "";
  PlacesDetailsResponse? placeId;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: initialPosition != null
            ? Stack(
                children: [
                  GoogleMap(
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition!,
                      zoom: 18.0,
                    ),
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    onCameraMove: (CameraPosition value) {
                      cameraPosition = value;
                    },
                    onCameraIdle: () async {
                      if (cameraPosition != null) {
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                cameraPosition!.target.latitude,
                                cameraPosition!.target.longitude);
                        String newLocation = placemarks.first.name !=
                                    placemarks.first.street &&
                                placemarks.first.name !=
                                    placemarks.first.subLocality
                            ? "${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}"
                            : "${placemarks.first.street}, ${placemarks.first.locality}";
                        PlacesDetailsResponse newPlaceId =
                            PlacesDetailsResponse(
                                status: 'true',
                                result: PlaceDetails(
                                    name: newLocation,
                                    formattedAddress: newLocation,
                                    placeId: "",
                                    geometry: Geometry(
                                        location: Location(
                                            lat:
                                                cameraPosition!.target.latitude,
                                            lng: cameraPosition!
                                                .target.longitude))),
                                htmlAttributions: []);
                        setState(() {
                          location = newLocation;
                          placeId = newPlaceId;
                        });
                      }
                    },
                  ),
                  Center(
                    child: Image.asset("assets/icons/pin.png", width: 42),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.my_location_outlined,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  location,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                dense: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (placeId != null) {
                                Navigator.pop(context, placeId);
                              } else {
                                toast('Select place 1st');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Confirm location',
                                    style:
                                        primaryTextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const Center(child: Text('Fetching location')));
  }

  Future<void> init() async {
    LatLng? currentPosition = await controller.getCurrentLatLng();
    setState(() {
      initialPosition = currentPosition;
    });
  }
}
