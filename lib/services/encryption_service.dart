import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  final String _key = '5RJasUkMpg1aeX+zZIWnYDOZTRMbfgV65QKpjiS9xQw=';

  Future<String?> encrypt({required String message}) async {
    final algorithm = AesCbc.with256bits(macAlgorithm: Hmac.sha512());
    final secretKey = SecretKey(base64Decode(_key));
    final nonce = algorithm.newNonce();
    final box = await algorithm.encrypt(
      utf8.encode(message),
      secretKey: secretKey,
      nonce: nonce,
    );
    final cipherText = box.concatenation();
    return base64Encode(cipherText);
  }

  Future<String?> decode({required String cipherText}) async {
    final algorithm = AesCbc.with256bits(macAlgorithm: Hmac.sha512());
    final secretKey = SecretKey(base64Decode(_key));
    final box = SecretBox.fromConcatenation(
      base64Decode(cipherText),
      nonceLength: 16,
      macLength: Hmac.sha512().macLength,
    );
    final message = await algorithm.decrypt(box, secretKey: secretKey);
    return utf8.decode(message);
  }
}
