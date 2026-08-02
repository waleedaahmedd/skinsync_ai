import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  final String _key = '8dad2ad89efc1d51d837cd94f90ed27c';

  Future<String?> encrypt({required String message}) async {
    final algorithm = AesCbc.with256bits(macAlgorithm: Hmac.sha512());
    final secretKey = SecretKey(utf8.encode(_key));
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
    final secretKey = SecretKey(utf8.encode(_key));
    final box = SecretBox.fromConcatenation(
      base64Decode(cipherText),
      nonceLength: 12,
      macLength: 16,
    );
    final message = await algorithm.decrypt(box, secretKey: secretKey);
    return utf8.decode(message);
  }
}
