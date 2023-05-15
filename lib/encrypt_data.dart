import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as material;
// import 'dart:convert';

class EncryptData {
  static const encryptionKey = "uKkxAih2i4k81ZGxrsTIHX8hsPt_E4b8XI642sr6sq0=";
  static var fernetDecrypted = "";

  static decryptFernet(plainText) {
    // final key = Key.fromUtf8(base64Url.encode(base64Url.decode(encryptionKey)));
    final fernet =
        Fernet(Key.fromBase64("uKkxAih2i4k81ZGxrsTIHX8hsPt_E4b8XI642sr6sq0="));
    final encrypter = Encrypter(fernet);
    try {
      fernetDecrypted = encrypter.decrypt(Encrypted.fromBase64(plainText));
      material.debugPrint(fernetDecrypted);
      return fernetDecrypted;
    } catch (e, s) {
      fernetDecrypted = "Error $e";
      material.debugPrint('Exception details:\n $e');
      material.debugPrint('Stack trace:\n $s');
      return fernetDecrypted;
    }
  }
}
