import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/app_network_image.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
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
  // final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(authViewModel).authData;
      if (data != null) {
        _nameController.text = data.user?.name ?? "";
        _phoneController.text = data.user?.phoneNumber ?? "";
        _emailController.text = data.user?.primaryEmail ?? "";
        // _locationController.text = data.user?.location ?? "";
        // _bioController.text = data.user?.bio ?? "";
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
          location: '',
          bio: '',
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
    // _locationController.dispose();
    // _bioController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(24)),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(8)),
                child: ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: CustomColors.darkPurple,
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: CustomFonts.black14w600,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(authViewModel.notifier)
                        .pickProfileImage(ImageSource.gallery);
                  },
                ),
              ),
              Divider(color: Colors.grey.shade100, height: context.h(1)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(8)),
                child: ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: CustomColors.darkPurple,
                  ),
                  title: Text('Take a Photo', style: CustomFonts.black14w600),
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(authViewModel.notifier)
                        .pickProfileImage(ImageSource.camera);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Personal Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(10)),
                _buildAvatar(context),
                SizedBox(height: context.h(24)),

                // Greeting Headers
                Text("Your Profile", style: CustomFonts.black26w600),
                SizedBox(height: context.h(4)),
                Text(
                  "Create your profile to personalize your SkinSync experience",
                  style: CustomFonts.grey12w400,
                ),
                SizedBox(height: context.h(24)),

                // Form Field Group Card
                Container(
                  padding: EdgeInsets.all(context.w(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.r(24)),
                    border: Border.all(
                      color: CustomColors.greyColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.015),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text("Full Name", style: CustomFonts.grey700_11w700),
                      SizedBox(height: context.h(6)),
                      TextFormField(
                        controller: _nameController,
                        style: CustomFonts.black13w600,
                        decoration: InputDecoration(
                          hintText: "Lizzy Johnson",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.w(14),
                            vertical: context.h(12),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: const BorderSide(
                              color: CustomColors.greyColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: const BorderSide(
                              color: CustomColors.purpleColor,
                            ),
                          ),
                        ),
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
                      SizedBox(height: context.h(16)),

                      // Phone Number
                      Text("Phone Number", style: CustomFonts.grey700_11w700),
                      SizedBox(height: context.h(6)),
                      PhoneWidget(
                        controller: _phoneController,
                        initialCountryCode: _selectedCountry?.countryCode,
                        onCountryChanged: (country) {
                          setState(() {
                            _selectedCountry = country;
                          });
                        },
                      ),
                      SizedBox(height: context.h(16)),

                      // Email Address
                      Text(
                        "Email Address (Primary)",
                        style: CustomFonts.grey700_11w700,
                      ),
                      SizedBox(height: context.h(6)),
                      TextFormField(
                        controller: _emailController,
                        style: CustomFonts.black13w600,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "lizzyjhonson@gmail.com",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.w(14),
                            vertical: context.h(12),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: const BorderSide(
                              color: CustomColors.greyColor,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
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
                      SizedBox(height: context.h(16)),

                      // Location
                      // Text("Location", style: CustomFonts.grey700_11w700),
                      // SizedBox(height: context.h(6)),
                      // TextField(
                      //   controller: _locationController,
                      //   style: CustomFonts.black13w600,
                      //   decoration: InputDecoration(
                      //     hintText: "New York",
                      //     contentPadding: EdgeInsets.symmetric(
                      //       horizontal: context.w(14),
                      //       vertical: context.h(12),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: const BorderSide(
                      //         color: CustomColors.greyColor,
                      //       ),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: BorderSide(color: Colors.grey.shade300),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: const BorderSide(
                      //         color: CustomColors.purpleColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: context.h(16)),

                      // Skin Goals Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Skin Type",
                                  style: CustomFonts.grey700_11w700,
                                ),
                                SizedBox(height: context.h(6)),
                                TextField(
                                  style: CustomFonts.black13w600,
                                  decoration: InputDecoration(
                                    hintText: "Skin Type +2",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: context.w(14),
                                      vertical: context.h(12),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: const BorderSide(
                                        color: CustomColors.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: const BorderSide(
                                        color: CustomColors.purpleColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: context.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Skin Goal",
                                  style: CustomFonts.grey700_11w700,
                                ),
                                SizedBox(height: context.h(6)),
                                TextField(
                                  style: CustomFonts.black13w600,
                                  decoration: InputDecoration(
                                    hintText: "Skin Goal +4",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: context.w(14),
                                      vertical: context.h(12),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: const BorderSide(
                                        color: CustomColors.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(14),
                                      ),
                                      borderSide: const BorderSide(
                                        color: CustomColors.purpleColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(16)),

                      // Primary Concerns
                      Text(
                        "Primary Concerns",
                        style: CustomFonts.grey700_11w700,
                      ),
                      SizedBox(height: context.h(6)),
                      TextField(
                        style: CustomFonts.black13w600,
                        decoration: InputDecoration(
                          hintText: "Primary Concerns +3",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.w(14),
                            vertical: context.h(12),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: const BorderSide(
                              color: CustomColors.greyColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            borderSide: const BorderSide(
                              color: CustomColors.purpleColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(16)),

                      // Bio
                      // Text(
                      //   "Bio / Description",
                      //   style: CustomFonts.grey700_11w700,
                      // ),
                      // SizedBox(height: context.h(6)),
                      // TextField(
                      //   controller: _bioController,
                      //   maxLines: 4,
                      //   style: CustomFonts.black13w600,
                      //   decoration: InputDecoration(
                      //     hintText: "Introduce yourself...",
                      //     contentPadding: EdgeInsets.symmetric(
                      //       horizontal: context.w(14),
                      //       vertical: context.h(12),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: const BorderSide(
                      //         color: CustomColors.greyColor,
                      //       ),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: BorderSide(color: Colors.grey.shade300),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(context.r(14)),
                      //       borderSide: const BorderSide(
                      //         color: CustomColors.purpleColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: context.h(24)),

                // Reusable Custom Button
                Consumer(
                  builder: (_, ref, _) {
                    final loading = ref.watch(
                      authViewModel.select((s) => s.loading),
                    );
                    if (loading) {
                      return const AppLoader();
                    }
                    return CustomButton(
                      text: "Save Changes",
                      isLoading: loading,
                      onPressed: _onSavePressed,
                    );
                  },
                ),
                SizedBox(height: context.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center _buildAvatar(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CustomColors.purpleColor.withValues(alpha: 0.4),
                width: context.w(4),
              ),
            ),
            child: ClipOval(
              child: Consumer(
                builder: (_, ref, _) {
                  final profileImage = ref.watch(
                    authViewModel.select((s) => s.profileImage),
                  );
                  if (profileImage != null) {
                    return Image.file(
                      File(profileImage.path),
                      fit: BoxFit.cover,
                      height: context.w(90),
                      width: context.w(90),
                    );
                  }
                  final profileUrl = ref
                      .read(authViewModel)
                      .authData
                      ?.user
                      ?.profileImageUrl;
                  return AppNetworkImage(
                    imageUrl: profileUrl ?? '',
                    fit: BoxFit.cover,
                    height: context.w(90),
                    width: context.w(90),
                    errorIcon: Icons.person_outline_rounded,
                    errorIconSize: context.sp(40),
                    errorIconColor: Colors.grey.shade400,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: context.w(32),
                width: context.w(32),
                decoration: BoxDecoration(
                  color: CustomColors.darkPurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Iconsax.camera,
                  size: context.w(15),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
