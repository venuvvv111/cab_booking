import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LocationAcessScreen extends StatefulWidget {
  const LocationAcessScreen({super.key});

  @override
  LocationAcessScreenState createState() => LocationAcessScreenState();
}

class LocationAcessScreenState extends State<LocationAcessScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: SizedBox(
                  width: double.infinity,
                  height: height,
                  child: Image.asset(
                    'assets/illustration/error_illustration/error40.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height - 300.0, left: 0.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                      ),
                      const Center(
                        child: Text(
                          "Location Access",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 29.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      const Center(
                        child: Text(
                          "Please enable location access\nto use this feature",
                          style: TextStyle(
                              fontFamily: "Sofia",
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      30.height,
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Container(
                              height: 45.0,
                              width: 150,
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                              child: const Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 30.0, right: 30.0),
                                  child: Text(
                                    "Allow access",
                                    style: TextStyle(
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
