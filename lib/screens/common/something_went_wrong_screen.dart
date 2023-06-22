import 'package:flutter/material.dart';

/// Component UI
class SomethingWentWrongScreen extends StatefulWidget {
  const SomethingWentWrongScreen({super.key});

  @override
  SomethingWentWrongScreenState createState() => SomethingWentWrongScreenState();
}

/// Component UI
class SomethingWentWrongScreenState extends State<SomethingWentWrongScreen> {
  @override

  /// Code Create UI Splash Screen
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
                    'assets/images/spilled_coffee.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height - 280.0, left: 0.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 9.0),
                      ),
                      const Center(
                        child: Text(
                          "Something Went Wrong!",
                          style: TextStyle(
                              fontSize: 22.0,
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
                          " Something unexpected happened\nPlease try again later.",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0),
                            child: Container(
                              height: 55.0,
                              width: 150,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50.0))),
                              child: const Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 30.0, right: 30.0),
                                      child: Text("Back",
                                          style: TextStyle(
                                            fontFamily: "Sofia",
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          )))),
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
