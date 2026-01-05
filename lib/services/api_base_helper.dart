import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:skinsync_ai/exceptions/app_exception.dart';

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
            Uri.parse(BaseUrls.api.url + endPoint.path + params),
            headers: getHeaders(),
          );
          return responseJson;
        case 'POST':
          final responseJson = await http.post(
            Uri.parse(BaseUrls.api.url + endPoint.path),
            headers: getHeaders(),
            body: jsonEncode(requestBody),
          );
          return responseJson;
        case 'PUT':
          final responseJson = await http.put(
            Uri.parse(BaseUrls.api.url + endPoint.path + params),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
          case 'PATCH':
          final responseJson = await http.patch(
            Uri.parse(BaseUrls.api.url + endPoint.path + params),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
          return responseJson;
        case 'DEL':
          final responseJson = await http.delete(
            Uri.parse(BaseUrls.api.url + endPoint.path + params),
            headers: getHeaders(),
          );
          return responseJson;
        case 'MULTIPART':
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(BaseUrls.api.url + endPoint.path),
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
      throw AppException('No Internet Connection');
    } on HttpException {
      throw AppException('No Internet Connection');
    } on FormatException {
      throw 'Invalid Format';
    } on TimeoutException {
      throw 'Request TimeOut';
    } catch (e) {
      throw e.toString();
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
