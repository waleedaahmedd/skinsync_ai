import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../utills/enums.dart';
import '../utills/secure_storage_service.dart';



class ApiBaseHelper {
  String? autToken;
  final SecureStorage _secureStorage = SecureStorage();



  Future<dynamic> httpRequest({
    required EndPoints endPoint,
    required String requestType,
    var requestBody,
    required String params,
    String? imagePath,
  }) async {
    autToken = _secureStorage.cachedAuthToken;
    try {
      switch (requestType) {
        case 'GET':
          final responseJson = await http.get(
            Uri.parse(BaseUrls.api.url + endPoint.url + params),
            headers: getHeaders(),
          );
          return responseJson;
        case 'POST':
          final responseJson = await http.post(
            Uri.parse(BaseUrls.api.url + endPoint.url),
            headers: getHeaders(),
            body: jsonEncode(requestBody),
          );
          return responseJson;
        case 'PUT':
          final responseJson = await http.put(
            Uri.parse(BaseUrls.api.url + endPoint.url + params),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
          return responseJson;
        case 'DEL':
          final responseJson = await http.delete(
            Uri.parse(BaseUrls.api.url + endPoint.url + params),
            headers: getHeaders(),
          );
          return responseJson;
        case 'MULTIPART':
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(BaseUrls.api.url + endPoint.url),
          );
          request.fields.addAll(requestBody!.toJson());
          request.files.add(
            await http.MultipartFile.fromPath('image', imagePath!),
          );
          request.headers.addAll(getHeaders());
          final responseJson = await request.send();
          return responseJson;
        default:
          throw Exception('Unsupported request type: $requestType');
      }
    } on SocketException {
      EasyLoading.showError('No Internet Connection');
      rethrow;
    } on HttpException {
      EasyLoading.showError('No Internet Connection');
      rethrow;
    } on FormatException {
      EasyLoading.showError('Invalid Format');
      rethrow;
    } on TimeoutException {
      EasyLoading.showError('Request TimeOut');
      rethrow;
    } catch (e) {
      EasyLoading.showError(e.toString());
      rethrow;
    }
  }

  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    headers.putIfAbsent('Content-Type', () => 'application/json');
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent('Authorization', () => 'Bearer ${autToken ?? ''}');
    return headers;
  }
}
