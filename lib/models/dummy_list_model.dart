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

class DummyAppointment {
  final String id;
  final String clinicName;
  final String doctorName;
  final String treatmentName;
  final List<String>? areas; // New field for treatment areas
  final DateTime date;
  final String time; // Slot format: "09:00 AM - 10:00 AM"
  final String type; // Consultation, Sessions, Follow-Up / Touch-Up, Provisional Booking
  final String status;

  DummyAppointment({
    required this.id,
    required this.clinicName,
    required this.doctorName,
    required this.treatmentName,
    this.areas,
    required this.date,
    required this.time,
    required this.type,
    this.status = "Scheduled",
  });
}

final List<DummyAppointment> dummyAppointments = [
  DummyAppointment(
    id: "1",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "BOTOX",
    areas: ["Forehead", "Cheeks"],
    date: DateTime(2024, 5, 20),
    time: "09:00 AM - 10:00 AM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "2",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "DERMAL FILLERS",
    areas: ["Lips", "Jawline"],
    date: DateTime(2024, 5, 20),
    time: "10:30 AM - 12:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "3",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "Chemical Peel",
    areas: ["Full Face"],
    date: DateTime(2024, 5, 21),
    time: "02:00 PM - 03:00 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "4",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "Laser Hair Removal",
    areas: ["Underarms", "Lower Legs"],
    date: DateTime(2024, 5, 22),
    time: "09:00 AM - 10:30 AM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "5",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "DERMAL FILLERS",
    areas: ["Midface"],
    date: DateTime(2024, 5, 20),
    time: "03:00 PM - 04:30 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "6",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "BOTOX",
    areas: ["Crow's Feet"],
    date: DateTime(2024, 5, 23),
    time: "01:00 PM - 02:00 PM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "7",
    clinicName: "Elite Dermatology",
    doctorName: "Dr. Michael Wilson",
    treatmentName: "Chemical Peel",
    date: DateTime(2024, 5, 21),
    time: "10:30 AM - 11:30 AM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "8",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "BOTOX",
    areas: ["Frown Lines"],
    date: DateTime(2024, 5, 24),
    time: "12:00 PM - 01:00 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "9",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "Laser Hair Removal",
    areas: ["Face"],
    date: DateTime(2024, 5, 22),
    time: "04:30 PM - 06:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "10",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "DERMAL FILLERS",
    areas: ["Cheeks", "Chin"],
    date: DateTime(2024, 5, 25),
    time: "11:00 AM - 12:30 PM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "11",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "Chemical Peel",
    date: DateTime(2024, 5, 20),
    time: "09:30 AM - 10:30 AM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "12",
    clinicName: "Elite Dermatology",
    doctorName: "Dr. Michael Wilson",
    treatmentName: "BOTOX",
    areas: ["Neck"],
    date: DateTime(2024, 5, 21),
    time: "03:30 PM - 04:30 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "13",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "DERMAL FILLERS",
    areas: ["Tear Trough"],
    date: DateTime(2024, 5, 26),
    time: "10:00 AM - 11:30 AM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "14",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "Laser Hair Removal",
    areas: ["Bikini Line"],
    date: DateTime(2024, 5, 23),
    time: "02:30 PM - 04:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "15",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "BOTOX",
    areas: ["Jawline"],
    date: DateTime(2024, 5, 27),
    time: "11:30 AM - 12:30 PM",
    type: "Consultation",
  ),
  DummyAppointment(
    id: "16",
    clinicName: "Elite Dermatology",
    doctorName: "Dr. Michael Wilson",
    treatmentName: "Chemical Peel",
    date: DateTime(2024, 5, 22),
    time: "01:00 PM - 02:00 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "17",
    clinicName: "Awaiting Clinic Confirmation",
    doctorName: "Pending",
    treatmentName: "BOTOX",
    areas: ["Forehead"],
    date: DateTime(2024, 5, 28),
    time: "09:00 AM - 10:00 AM",
    type: "Provisional Booking",
  ),
  DummyAppointment(
    id: "18",
    clinicName: "Glow Skin Clinic",
    doctorName: "Dr. Sarah Smith",
    treatmentName: "Laser Hair Removal",
    areas: ["Full Arms"],
    date: DateTime(2024, 5, 20),
    time: "05:00 PM - 06:30 PM",
    type: "Sessions",
  ),
  DummyAppointment(
    id: "19",
    clinicName: "Skin Sync Center",
    doctorName: "Dr. Emily Brown",
    treatmentName: "DERMAL FILLERS",
    areas: ["Nasolabial Folds"],
    date: DateTime(2024, 5, 29),
    time: "12:30 PM - 02:00 PM",
    type: "Follow-Up / Touch-Up",
  ),
  DummyAppointment(
    id: "20",
    clinicName: "Radiance Care",
    doctorName: "Dr. John Doe",
    treatmentName: "Chemical Peel",
    date: DateTime(2024, 5, 24),
    time: "03:00 PM - 04:00 PM",
    type: "Sessions",
  ),
];
