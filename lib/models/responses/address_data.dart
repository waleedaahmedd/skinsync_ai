import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressData {
  final LatLng latLng;
  final String? address;

  const AddressData({required this.latLng, required this.address});
}
