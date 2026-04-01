import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:skinsync_ai/exceptions/app_exception.dart';
import 'package:skinsync_ai/models/responses/address_data.dart';
import 'package:skinsync_ai/models/responses/geocoding_response.dart';
import 'package:skinsync_ai/models/responses/map_clinics_response.dart'
    hide Location;

class LocationService {
  static LocationService? _instance;

  factory LocationService() {
    return _instance ??= LocationService._();
  }

  LocationService._();

  static final String _apiKey = 'AIzaSyDCkkGnM5MsciCvDYI7A_70Px-UiM3Ir8Q';
  static const String _url =
      'https://maps.googleapis.com/maps/api/geocode/json';

  Future<AddressData?> fetchAddress() async {
    final service = Location();
    final permission = await service.requestPermission();
    if (permission != PermissionStatus.granted) {
      throw AppException('Location permission denied!');
    }
    final granted = await service.requestService();
    if (!granted) {
      throw AppException('Location service denied!');
    }
    final data = await service.getLocation();
    if (data.latitude == null || data.longitude == null) {
      throw AppException('Could not fetch location!');
    }
    final address = await getAddressFromLatLng(data.latitude!, data.longitude!);
    return AddressData(
      latLng: LatLng(data.latitude!, data.longitude!),
      address: address,
    );
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    final url = '$_url?latlng=$latitude,$longitude&key=$_apiKey';
    log('URL: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw AppException('Could not fetch address!');
    }
    log('RESPONSE: ${response.body}');
    final data = GeocodingResponse.fromJson(jsonDecode(response.body));
    if (data.results?.isEmpty ?? true) {
      throw AppException('No address found!');
    }
    return data.results!.first.formattedAddress!;
  }

  Future<List<Place>> fetchNearbyClinics({required LatLng location}) async {
    final uri = Uri.parse('https://places.googleapis.com/v1/places:searchText');
    final body = {
      'textQuery': 'MedSpa Clinic',
      'maxResultCount': 100,
      'locationBias': {
        'circle': {
          'center': {
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
          'radius': 1000,
        },
      },
    };
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': '*',
    };
    final response = await post(uri, body: jsonEncode(body), headers: headers);
    final jsonString = response.body;
    return MapClinicsResponse.fromJson(jsonDecode(jsonString)).places ?? [];
  }
}
