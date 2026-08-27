
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';
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
  // final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    // _locationController.dispose();
    // _bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authViewModel);
    _emailController.text = authState.authData?.user?.primaryEmail ?? '';
    final cc = authState.authData?.user?.cc;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(authViewModel.notifier)
          .setCountryCode(Country.parse(cc ?? "US"));
    });

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
    final profileImage = ref.watch(authViewModel).profileImage;

    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context)),
        decoration: const BoxDecoration(
          gradient: CustomColors.purpleWhiteBlueGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(30)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(104)),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: profileImage != null
                            ? Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                                height: context.w(75),
                                width: context.w(75),
                              )
                            : Image.asset(
                                DummyAssets.profile,
                                fit: BoxFit.cover,
                                height: context.w(75),
                                width: context.w(75),
                              ),
                      ),
                      Positioned(
                        bottom: -6, // or 0
                        right: -6,
                        child: Container(
                          height: context.w(35),
                          width: context.w(35),
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
                                size: context.w(21),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(27)),
                  Text("Your Profile", style: CustomFonts.black30w600),
                  SizedBox(height: context.h(4)),
                  Text(
                    "Create your profile to personalize your SkinSync experience.",
                    style: CustomFonts.black18w400,
                  ),
                  SizedBox(height: context.h(22)),
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
                  SizedBox(height: context.h(20)),
                  PhoneWidget(
                    enableCountrySelection: !isDeploymentMode,
                    controller: _phoneController,
                    initialCountryCode: ref
                        .read(authViewModel)
                        .country
                        .countryCode,
                    onCountryChanged: (country) {
                      ref.read(authViewModel.notifier).setCountryCode(country);
                    },
                  ),
                  SizedBox(height: context.h(20)),
                  TextFormField(
                    readOnly: true,
                    controller: _emailController,
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(
                      hintText: "Email Address",
                    ),
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
                  // SizedBox(height: context.h(20)),
                  // TextFormField(
                  //   controller: _locationController,
                  //   style: CustomFonts.black18w400,
                  //   decoration: const InputDecoration(hintText: "Location"),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return 'Please enter your location';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: context.h(20)),
                  // TextFormField(
                  //   controller: _bioController,
                  //   style: CustomFonts.black18w400,
                  //   maxLines: 4,
                  //   decoration: const InputDecoration(hintText: "Bio"),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return 'Please enter your Bio';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: context.h(35)),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      isLoading: ref.watch(authViewModel).loading,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState?.validate() ?? false) {
                          ref
                              .read(authViewModel.notifier)
                              .callOnboardingProfileApi(
                                name: _nameController.text,
                                phoneNumber: _phoneController.text.trim(),
                                emailAddress: _emailController.text.trim(),
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
                      text: "Next",
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
