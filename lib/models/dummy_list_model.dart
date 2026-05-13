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
