import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/phone_widget.dart';

import 'get_notified_screen.dart';

class YourProfileScreen extends ConsumerStatefulWidget {
  const YourProfileScreen({super.key});
  static const String routeName = '/YourProfileScreen';

  @override
  ConsumerState<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends ConsumerState<YourProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Country? _selectedCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authViewModel);
    _emailController.text =
        authState.authResponse?.data?.user?.primaryEmail ?? '';

    // Initialize country if user data exists
    // TODO: CC Not provided in AuthResponse, uncomment when response is
    // TODO: fixed
    // final user = authState.authResponse?.data?.userDetails;
    // if (user?.cc != null) {
    //   try {
    //     _selectedCountry = Country.parse(user!.cc!);
    //   } catch (e) {
    //     _selectedCountry = Country.parse('US');
    //   }
    // } else {
    //   _selectedCountry = Country.parse('US');
    // }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(authViewModel.notifier)
                      .pickProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(authViewModel.notifier)
                      .pickProfileImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = ref.watch(authViewModel).profileImage;

    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context)),
        decoration: const BoxDecoration(
          gradient: CustomColors.purpleWhiteBlueGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 104.h),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: profileImage != null
                            ? Image.file(
                                File(profileImage.path),
                                fit: BoxFit.cover,
                                height: 75.w,
                                width: 75.w,
                              )
                            : Image.asset(
                                DummyAssets.profile,
                                fit: BoxFit.cover,
                                height: 75.w,
                                width: 75.w,
                              ),
                      ),
                      Positioned(
                        bottom: -6, // or 0
                        right: -6,
                        child: Container(
                          height: 35.w,
                          width: 35.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: _showImageSourceDialog,
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.black,
                                size: 21.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27.h),
                  Text("Your Profile", style: CustomFonts.black30w600),
                  SizedBox(height: 4.h),
                  Text(
                    "Create your profile to personalize your SkinSync experience.",
                    style: CustomFonts.black18w400,
                  ),
                  SizedBox(height: 22.h),
                  TextFormField(
                    controller: _nameController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "Your Name"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  PhoneWidget(
                    controller: _phoneController,
                    initialCountryCode: _selectedCountry?.countryCode,
                    onCountryChanged: (country) {
                      setState(() {
                        _selectedCountry = country;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    readOnly: true,
                    controller: _emailController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "Email Address"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegExp = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegExp.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _locationController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "Location"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _bioController,
                    style: CustomFonts.black18w400,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: "Bio"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Bio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 35.h),
                  SizedBox(
                    width: double.infinity,
                    child: ref.watch(authViewModel).loading
                        ? const AppLoader()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ref
                                    .read(authViewModel.notifier)
                                    .callOnboardingProfileApi(
                                      name: _nameController.text,
                                      phoneNumber: _phoneController.text.trim(),
                                      emailAddress: _emailController.text
                                          .trim(),
                                      location: _locationController.text.trim(),
                                      bio: _bioController.text.trim(),
                                      cc: _selectedCountry?.countryCode,
                                      country: _selectedCountry?.name,
                                    )
                                    .then((value) {
                                      if (value == true) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          GetNotifiedScreen.routeName,
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    });
                              }
                            },
                            child: ref.watch(authViewModel).loading
                                ? const CircularProgressIndicator()
                                : const Text("Next"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
