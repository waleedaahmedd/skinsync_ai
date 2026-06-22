class OnBoardingProfileRequest {
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String location;
  final String bio;
  final String? profileImageUrl;
  final String? cc;
  final String? country;

  OnBoardingProfileRequest({
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.location,
    required this.bio,
    this.profileImageUrl,
    this.cc,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'location': location,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'cc': cc,
      'country': country,
    };
  }
}
