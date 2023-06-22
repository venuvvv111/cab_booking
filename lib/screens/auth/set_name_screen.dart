import 'package:figgocabs/controllers/profile_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class SetNameScreen extends StatefulWidget {
  const SetNameScreen({Key? key}) : super(key: key);

  @override
  State<SetNameScreen> createState() => _SetNameScreenState();
}

class _SetNameScreenState extends State<SetNameScreen> {
  var profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Tell us your name', style: boldTextStyle(size: 28)),
              ),
              56.height,
              TextFormField(
                controller: profileController.userNameController.value,
                decoration: inputDecoration(context,
                    hintText: "Enter your full name",
                    prefixIcon: Icons.watch_later_rounded),
              ),
              16.height,
              Container(
                height: 46,
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {
                    profileController.setName(context);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
