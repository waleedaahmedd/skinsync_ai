import '../utills/assets.dart';

class Treatments {
  final String svg;
  final String title;
  Treatments({required this.title, required this.svg});
}

final List<Treatments> treatments = [
  Treatments(title: "DERMAL FILLERS", svg: SvgAssets.treatment),
  Treatments(title: "BOTOX", svg: SvgAssets.treatment),
];

final List<Treatments> sections = [
  Treatments(title: "Upper Face", svg: PngAssets.splashLogo),
  Treatments(title: "Midface", svg: PngAssets.splashLogo),
  Treatments(title: "Lower Face", svg: PngAssets.splashLogo),
  Treatments(title: "Jawline", svg: PngAssets.splashLogo),
];

final List<Treatments> subSections = [
  Treatments(title: "Tear Trough", svg: SvgAssets.treatment),
  Treatments(title: "Cheeks/ Midface", svg: SvgAssets.treatment),
  Treatments(title: "Nasolabial Folds", svg: SvgAssets.treatment),
  Treatments(title: "Preauricular Area", svg: SvgAssets.treatment),
];

class DummySession {
  final DateTime date;
  final String doctorName;
  final String clinicName;
  final String type; // Session or Follow-up
  final String outcome;
  final List<String> products;
  final String materials; // e.g., "2 Syringes", "50 Units"
  final String postCare;

  DummySession({
    required this.date,
    required this.doctorName,
    required this.clinicName,
    required this.type,
    required this.outcome,
    required this.products,
    required this.materials,
    required this.postCare,
  });
}

class DummyAppointment {
  final String id;
  final String clinicName;
  final String doctorName;
  final String treatmentName;
  final String area; 
  final DateTime date;
  final String time; 
  final String type; 
  final String status;
  final String notes;
  final List<DummySession> pastSessions;

  DummyAppointment({
    required this.id,
    required this.clinicName,
    required this.doctorName,
    required this.treatmentName,
    required this.area,
    required this.date,
    required this.time,
    required this.type,
    this.status = "Scheduled",
    this.notes = "Patient requested subtle results with focus on natural appearance.",
    this.pastSessions = const [],
  });
}

class DummyDoctor {
  final String id;
  final String name;
  final String image;
  final String specialization;
  final String clinicName;
  final double rating;

  DummyDoctor({
    required this.id,
    required this.name,
    required this.image,
    required this.specialization,
    required this.clinicName,
    required this.rating,
  });
}

class DummyClinic {
  final String id;
  final String name;
  final String image;
  final String address;
  final int treatmentCount;
  final int doctorCount;

  DummyClinic({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.treatmentCount,
    required this.doctorCount,
  });
}

final List<DummyDoctor> dummyDoctors = [
  DummyDoctor(
    id: "1",
    name: "Dr. Sarah Smith",
    image: "https://t4.ftcdn.net/jpg/03/20/52/31/360_F_320523164_cc7at9W77BRD96qLYpSPlSdrofD8oM0S.jpg",
    specialization: "Dermatologist",
    clinicName: "Glow Skin Clinic",
    rating: 4.8,
  ),
  DummyDoctor(
    id: "2",
    name: "Dr. John Doe",
    image: "https://t3.ftcdn.net/jpg/02/60/04/08/360_F_260040863_7y7D6shY6K75YI0yS2666OAXm0C46RRT.jpg",
    specialization: "Cosmetic Surgeon",
    clinicName: "Radiance Care",
    rating: 4.9,
  ),
  DummyDoctor(
    id: "3",
    name: "Dr. Emily Brown",
    image: "https://t4.ftcdn.net/jpg/03/17/85/49/360_F_317854905_2idSd8Kps97L9p85nL8k8uK07NMTQ3mF.jpg",
    specialization: "Aesthetic Physician",
    clinicName: "Skin Sync Center",
    rating: 4.7,
  ),
  DummyDoctor(
    id: "4",
    name: "Dr. Michael Wilson",
    image: "https://t3.ftcdn.net/jpg/02/95/51/80/360_F_295518052_NmSFeE1VPVCu499rkcyYpL6x6686K856.jpg",
    specialization: "Laser Specialist",
    clinicName: "Elite Dermatology",
    rating: 4.6,
  ),
];

final List<DummyClinic> topClinics = [
  DummyClinic(
    id: "1",
    name: "Glow Skin Clinic",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s",
    address: "Bedford-Stuyvesant, Brooklyn, NY",
    treatmentCount: 25,
    doctorCount: 8,
  ),
  DummyClinic(
    id: "2",
    name: "Radiance Care",
    image: "https://images.squarespace-cdn.com/content/v1/5b3a6e9f1aef1db0d7a0c7e2/1531149791485-Y86L86E8N8V8M8N8Y8N8/Radiance-Care-Logo.png",
    address: "Manhattan, New York, NY",
    treatmentCount: 40,
    doctorCount: 12,
  ),
  DummyClinic(
    id: "3",
    name: "Skin Sync Center",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0_7K8G9C8g_9n9k_y_x_w_v_z_y_x_w_v_z_y_x_w_v_z_y_x_w_v_z&s",
    address: "Queens, New York, NY",
    treatmentCount: 30,
    doctorCount: 10,
  ),
];

final List<DummySession> _botoxCheeksHistory = [

  DummySession(
    date: DateTime(2024, 1, 10),
    doctorName: "Dr. Sarah Smith",
    clinicName: "Glow Skin Clinic",
    type: "Session",
    outcome: "Successful initial application. Slight swelling resolved in 2 days.",
    products: ["Botox Cosmetic"],
    materials: "25 Units",
    postCare: "Avoid heavy exercise for 24 hours. Keep upright for 4 hours.",
  ),
  DummySession(
    date: DateTime(2024, 1, 24),
    doctorName: "Dr. Sarah Smith",
    clinicName: "Glow Skin Clinic",
    type: "Follow-up",
    outcome: "Results look natural. No touch-up required.",
    products: [],
    materials: "N/A",
    postCare: "Continue standard skincare routine.",
  ),
];

final List<DummyAppointment> dummyAppointments = [
  // Grouped on May 20
  DummyAppointment(
    id: "1",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "BOTOX",
    area: "Forehead",
    date: DateTime(2024, 5, 20),
    time: "09:00 AM - 10:00 AM",
    type: "Consultation",
    pastSessions: _botoxCheeksHistory,
  ),
  DummyAppointment(
    id: "2",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "BOTOX",
    area: "Cheeks",
    date: DateTime(2024, 5, 20),
    time: "10:00 AM - 11:00 AM",
    type: "Consultation",
    pastSessions: _botoxCheeksHistory,
  ),
  DummyAppointment(
    id: "3",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "DERMAL FILLERS",
    area: "Lips",
    date: DateTime(2024, 5, 20),
    time: "11:30 AM - 12:30 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "4",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "DERMAL FILLERS",
    area: "Jawline",
    date: DateTime(2024, 5, 20),
    time: "12:30 PM - 01:30 PM",
    type: "Sessions",
  ),

  // Grouped on May 21
  DummyAppointment(
    id: "5",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "Chemical Peel",
    area: "Full Face",
    date: DateTime(2024, 5, 21),
    time: "02:00 PM - 03:00 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "6",
    clinicName: "Elite Dermatology",
    doctorName: "Dr. Michael Wilson",
    treatmentName: "BOTOX",
    area: "Neck",
    date: DateTime(2024, 5, 21),
    time: "03:30 PM - 04:30 PM",
    type: "Sessions",
  ),

  // Grouped on May 22
  DummyAppointment(
    id: "7",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "Laser Hair Removal",
    area: "Underarms",
    date: DateTime(2024, 5, 22),
    time: "09:00 AM - 10:00 AM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "8",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "Laser Hair Removal",
    area: "Lower Legs",
    date: DateTime(2024, 5, 22),
    time: "10:00 AM - 11:30 AM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "9",
    clinicName: "Elite Dermatology",
    doctorName: "Dr. Michael Wilson",
    treatmentName: "Chemical Peel",
    area: "Hands",
    date: DateTime(2024, 5, 22),
    time: "01:00 PM - 02:00 PM",
    type: "Sessions",
  ),

  // Individual dates
  DummyAppointment(
    id: "10",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "BOTOX",
    area: "Crow's Feet",
    date: DateTime(2024, 5, 23),
    time: "01:00 PM - 02:00 PM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "11",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "BOTOX",
    area: "Frown Lines",
    date: DateTime(2024, 5, 24),
    time: "12:00 PM - 01:00 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "12",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "DERMAL FILLERS",
    area: "Cheeks",
    date: DateTime(2024, 5, 25),
    time: "11:00 AM - 12:00 PM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "13",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "DERMAL FILLERS",
    area: "Chin",
    date: DateTime(2024, 5, 25),
    time: "12:00 PM - 01:00 PM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "14",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "DERMAL FILLERS",
    area: "Tear Trough",
    date: DateTime(2024, 5, 26),
    time: "10:00 AM - 11:00 AM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "15",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "BOTOX",
    area: "Jawline",
    date: DateTime(2024, 5, 27),
    time: "11:30 AM - 12:30 PM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "16",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "BOTOX",
    area: "Forehead",
    date: DateTime(2024, 5, 28),
    time: "09:00 AM - 10:00 AM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "17",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "DERMAL FILLERS",
    area: "Nasolabial Folds",
    date: DateTime(2024, 5, 29),
    time: "12:30 PM - 01:30 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "18",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "Chemical Peel",
    area: "Neck",
    date: DateTime(2024, 5, 24),
    time: "03:00 PM - 04:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "19",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "Laser Hair Removal",
    area: "Full Arms",
    date: DateTime(2024, 5, 20),
    time: "05:00 PM - 06:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "20",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "Laser Hair Removal",
    area: "Underarms",
    date: DateTime(2024, 5, 20),
    time: "06:00 PM - 06:30 PM",
    type: "Sessions",
  ),
];
