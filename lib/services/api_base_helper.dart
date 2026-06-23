import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exceptions/app_exception.dart';
import '../screens/get_started_screen.dart';

import '../app_init.dart';
import '../main.dart';
import '../models/responses/refresh_token_response.dart';
import '../utills/enums.dart';
import '../utills/secure_storage_service.dart';

class ApiBaseHelper {
  String? authToken;
  final SecureStorage _secureStorage = SecureStorage();

  Future<http.Response> httpRequest({
    required EndPoints endPoint,
    required String requestType,
    var requestBody,
    String? params,
    String? imagePath,
  }) async {
    authToken = await _secureStorage.getToken();

    try {
      final baseUrl = isDeploymentMode ? BaseUrls.api.url : BaseUrls.apiQa.url;
      final url = '$baseUrl${endPoint.path}${params ?? ''}';
      log('URL: $url');
      log('BODY: $requestBody');
      await _refreshToken();
      switch (requestType) {
        case 'GET':
          final responseJson = await http.get(
            Uri.parse(url),
            headers: getHeaders(),
          );
          log('RESPONSE: ${responseJson.body}');
          return responseJson;
        case 'POST':
          final responseJson = await http.post(
            Uri.parse(url),
            headers: getHeaders(),
            body: jsonEncode(requestBody),
          );
          log('RESPONSE: ${responseJson.body}');
          return responseJson;
        case 'PUT':
          return await http.put(
            Uri.parse(url),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
        case 'PATCH':
          final responseJson = await http.patch(
            Uri.parse(url),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
          return responseJson;
        case 'DELETE':
          final responseJson = await http.delete(
            Uri.parse(url),
            headers: getHeaders(),
            body: requestBody != '' ? jsonEncode(requestBody) : null,
          );
          return responseJson;
        case 'MULTIPART':
          final request = http.MultipartRequest('POST', Uri.parse(url));
          request.fields.addAll(requestBody!.toJson());
          request.files.add(
            await http.MultipartFile.fromPath('image', imagePath!),
          );
          request.headers.addAll(getHeaders());
          final responseJson = await request.send();
          return http.Response.fromStream(responseJson);
        default:
          throw Exception('Unsupported request type: $requestType');
      }
    } on SocketException {
      throw const AppException('No Internet Connection');
    } on HttpException {
      throw const AppException('No Internet Connection');
    } on FormatException {
      throw 'Invalid Format';
    } on TimeoutException {
      throw 'Request TimeOut';
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        await _secureStorage.clearAllSecureStrings();
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          GetStartedScreen.routeName,
          (_) => false,
        );
      }
      throw e.toString();
    }
  }

  Map<String, String> getHeaders() {
    log("Auth token $authToken");
    Map<String, String> headers = {};
    headers.putIfAbsent('Content-Type', () => 'application/json');
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent('Authorization', () => 'Bearer ${authToken ?? ''}');
    return headers;
  }

  Future<void> _refreshToken() async {
    final token = await _secureStorage.getToken();
    if (token == null) {
      log('TOKEN IS NULL');
      return;
    }
    final expiry = await _secureStorage.getAccessTokenExpiry();
    final now = DateTime.now();
    if (expiry?.isAfter(now) ?? false) {
      log('TOKEN IS NOT EXPIRED');
      return;
    }
    final refreshExpiry = await _secureStorage.getRefreshTokenExpiry();
    if (refreshExpiry?.isBefore(now) ?? true) {
      log('REFRESH TOKEN IS EXPIRED');
      throw Exception('Unauthorized');
    }
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      log('REFRESH TOKEN IS NULL');
      throw Exception('Unauthorized');
    }
    log('EXPIRY: $expiry');
    log('REFRESH EXPIRY: $refreshExpiry');
    final uri = Uri.parse('${BaseUrls.api.url}${EndPoints.refreshToken.path}');
    log('URL: $uri');
    final request = {'refresh_token': refreshToken};
    log('REQUEST: $request');
    final json = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode(request),
    );
    log('RESPONSE: ${json.body}');
    final response = RefreshTokenResponse.fromJson(jsonDecode(json.body));
    if (!(response.status ?? false)) {
      throw Exception('Unauthorized');
    }
    await _secureStorage.saveToken(response.data!.accessToken!);
    await _secureStorage.saveRefreshToken(response.data!.refreshToken!);
    await _secureStorage.saveAccessTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.accessExpiresAt! * 1000,
      ),
    );
    await _secureStorage.saveRefreshTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.refreshExpiresAt! * 1000,
      ),
    );
    log('TOKEN REFRESHED');
  }
}
