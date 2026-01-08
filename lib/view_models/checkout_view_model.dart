import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';

import '../screens/bottom_nav_screens/treatments_screen.dart';
import '../screens/explore_clinics_screen.dart';
import 'base_view_model.dart';

final checkoutViewModel = NotifierProvider(() => CheckoutViewModel());

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  CheckoutViewModel() : super(initialState: const CheckoutState());

  @override
  CheckoutState build() {
    // Keep the provider alive to prevent disposal during navigation
    ref.keepAlive();
    return super.build();
  }

  void updateState({
    int? treatmentId,
    int? treatmentAreaId,
    int? treatmentSubAreaId,
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    print("state updated");
    state = CheckoutState(
      treatmentId: treatmentId ?? state.treatmentId,
      treatmentAreaId: treatmentAreaId ?? state.treatmentAreaId,
      treatmentSubAreaId: treatmentSubAreaId ?? state.treatmentSubAreaId,
      clinicId: clinicId ?? state.clinicId,
      drId: drId ?? state.drId,
      appointmentDate: appointmentDate ?? state.appointmentDate,
      appointmentTime: appointmentTime ?? state.appointmentTime,
      capturedImage: capturedImage ?? state.capturedImage,
    );
  }

  void clearState() {
    print("state Cleared");
    state = CheckoutState(
      treatmentId: null,
      treatmentAreaId: null,
      treatmentSubAreaId: null,
      clinicId: null,
      drId: null,
      appointmentDate: null,
      appointmentTime: null,
      capturedImage: null,
    );
  }

  String navigateTo() {
    if (state.treatmentId == null) {
      return TreatmentsScreen.routeName;
    } else if (state.capturedImage == null) {
      return FaceDetectionScreen.routeName;
    } else if (state.clinicId == null) {
      return ExploreClinicsScreen.routeName;
    } else {
      return "/error";
    }
  }
}

class CheckoutState {
  final int? treatmentId;
  final int? treatmentAreaId;
  final int? treatmentSubAreaId;
  final String? clinicId;
  final String? drId;
  final String? appointmentDate;
  final String? appointmentTime;
  final XFile? capturedImage;

  const CheckoutState({
    this.treatmentId,
    this.treatmentAreaId,
    this.treatmentSubAreaId,
    this.clinicId,
    this.drId,
    this.appointmentDate,
    this.appointmentTime,
    this.capturedImage,
  });

  CheckoutState copyWith({
    int? treatmentId,
    int? treatmentAreaId,
    int? treatmentSubAreaId,
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    return CheckoutState(
      treatmentId: treatmentId ?? this.treatmentId,
      treatmentAreaId: treatmentAreaId ?? this.treatmentAreaId,
      treatmentSubAreaId: treatmentSubAreaId ?? this.treatmentSubAreaId,
      clinicId: clinicId ?? this.clinicId,
      drId: drId ?? this.drId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      capturedImage: capturedImage ?? this.capturedImage,
    );
  }
}
