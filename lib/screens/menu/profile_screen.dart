import 'dart:io';

import 'package:figgocabs/controllers/profile_controller.dart';
import 'package:figgocabs/utility/app_theme.dart';
import 'package:figgocabs/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  String? imagePath;
  String? userImage;
  bool state = true;

  var profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.getProfile(true);
  }

  File? _imageFile;
  String? imageUrl;

  Future<void> _selectImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(imageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context, "Edit profile", false),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: GetBuilder<ProfileController>(
              builder: (controller) => Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: controller.isFetchingProfile
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.staggeredDotsWave(
                                color: primaryColor, size: 56),
                            12.height,
                            Text(
                              controller.message,
                              style: primaryTextStyle(size: 16),
                            )
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectImage();
                                },
                                child: CircleAvatar(
                                        radius: 45,
                                        backgroundColor: primaryColor,
                                        child: _imageFile == null
                                            ? controller
                                            .profileModel
                                            .data
                                            .profileImage.isNotEmpty ? Image.network(controller
                                            .profileModel
                                            .data
                                            .profileImage) : const Icon(Icons.account_circle,
                                            size: 90)
                                            : Image.file(
                                          _imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 8,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.edit,
                                        color: white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: controller.userNameController.value,
                            focusNode: controller.f1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter user name';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              controller.f1.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(controller.f2);
                            },
                            decoration:
                                inputDecoration(context, hintText: "Full name"),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller:
                                controller.userDateOfBirthController.value,
                            focusNode: controller.f3,
                            readOnly: true,
                            onTap: () {
                              controller.selectDateAndTime(context);
                            },
                            onFieldSubmitted: (v) {
                              controller.f3.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(controller.f4);
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: "Date of Birth",
                              suffixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: gray),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: controller.userEmailController.value,
                            focusNode: controller.f4,
                            onFieldSubmitted: (v) {
                              controller.f4.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(controller.f5);
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: "Email",
                              suffixIcon: const Icon(Icons.mail_outline_rounded,
                                  size: 16, color: gray),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller:
                                controller.userContactNumberController.value,
                            focusNode: controller.f5,
                            onFieldSubmitted: (v) {
                              controller.f5.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(controller.f6);
                            },
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(context,
                                hintText: "Phone number"),
                          ),
                          15.height,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultRadius)),
                              backgroundColor: const Color(0xFFF8F8F8),
                            ),
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: DropdownButton<String>(
                              value: controller.dropdownValue,
                              elevation: 16,
                              style: primaryTextStyle(),
                              hint: Text('Gender', style: primaryTextStyle()),
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (newValue) {
                                controller.updateGender(newValue.toString());
                              },
                              items: <String>[
                                'Male',
                                'Female',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          30.height,
                          controller.isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: primaryColor, size: 28)
                              : GestureDetector(
                                  onTap: () {
                                    _imageFile != null
                                        ? profileController.uploadImage(
                                            _imageFile!, context)
                                        : controller.updateProfile();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child: Text('Update',
                                        style: boldTextStyle(color: white)),
                                  ),
                                ),
                          8.height,
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
