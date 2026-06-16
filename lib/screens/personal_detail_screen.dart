import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../utills/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/phone_widget.dart';

class PersonalDetailScreen extends ConsumerStatefulWidget {
  const PersonalDetailScreen({super.key});
  static const String routeName = '/PersonalDetailScreen';

  @override
  ConsumerState<PersonalDetailScreen> createState() =>
      _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends ConsumerState<PersonalDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(authViewModel).authResponse?.data;
      if (data != null) {
        _nameController.text = data.user?.name ?? "";
        _phoneController.text = data.user?.phoneNumber ?? "";
        _emailController.text = data.user?.primaryEmail ?? "";
        _locationController.text = data.user?.location ?? "";
        _bioController.text = data.user?.bio ?? "";
        // TODO: CC Not provided in AuthResponse, uncomment when response is
        // TODO: fixed
        // if (user.cc != null) {
        //   try {
        //     setState(() {
        //       _selectedCountry = Country.parse(user.cc!);
        //     });
        //   } catch (e) {
        //     _selectedCountry = Country.parse('US');
        //   }
        // }
      }
    });
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final success = await ref
        .read(authViewModel.notifier)
        .callOnboardingProfileApi(
          name: _nameController.text,
          phoneNumber: _phoneController.text.trim(),
          emailAddress: _emailController.text.trim(),
          location: _locationController.text.trim(),
          bio: _bioController.text.trim(),
        );
    if (success ?? false) {
      EasyLoading.showSuccess('Profile updated!');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
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
      appBar: const CustomAppBar(showTitle: true, title: "Personal Details"),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 28.h),
                  Stack(
                    alignment: Alignment.center,
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
                            : Image.network(
                                ref
                                        .read(authViewModel)
                                        .authResponse
                                        ?.data
                                        ?.user
                                        ?.profileImageUrl ??
                                    "",
                                fit: BoxFit.cover,
                                height: 91.w,
                                width: 91.w,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    height: 91.w,
                                    width: 91.w,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40.sp,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Container(
                          height: 35.w,
                          width: 35.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _showImageSourceDialog,
                            icon: Icon(
                              Iconsax.camera,
                              size: 20.w,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Text("Your Profile", style: CustomFonts.black30w600),
                  Text(
                    "Create your profile to personalize your SkinSync experience",
                    style: CustomFonts.grey18w400,
                  ),
                  SizedBox(height: 22.h),
                  TextFormField(
                    controller: _nameController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "Lizzy Johnson"),
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
                    controller: _emailController,
                    style: CustomFonts.black18w400,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: "lizzyjhonson@gmail.com",
                    ),
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
                  TextField(
                    controller: _locationController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "New York"),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: CustomFonts.black18w400,
                          decoration: const InputDecoration(hintText: "Skin Type +2"),
                        ),
                      ),
                      SizedBox(width: 12.39.h),
                      Expanded(
                        child: TextField(
                          style: CustomFonts.black18w400,
                          decoration: const InputDecoration(hintText: "Skin Goal +4"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(
                      hintText: "Primary Concerns  +3",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: _bioController,
                    maxLines: 4,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(hintText: "Bio"),
                  ),
                  SizedBox(height: 35.h),
                  Consumer(
                    builder: (_, ref, _) {
                      final loading = ref.watch(
                        authViewModel.select((s) => s.loading),
                      );
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _onSavePressed,
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text("Save"),
                        ),
                      );
                    },
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
