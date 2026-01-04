import 'dart:convert';

class OnBoardingProfileRequest {
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String location;
  final String bio;


  OnBoardingProfileRequest({
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.location,
    required this.bio,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'location': location,
      'bio': bio,
      
    };
  }


  }

