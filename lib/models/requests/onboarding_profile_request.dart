
class OnBoardingProfileRequest {
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String location;
  final String bio;
  final String? profileImageUrl;


  OnBoardingProfileRequest({
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.location,
    required this.bio,
    this.profileImageUrl,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'location': location,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      
    };
  }


  }

