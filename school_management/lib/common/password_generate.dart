import 'dart:math';

import 'package:gainer_crypto/encrypt_decrypt.dart';

class PasswordGenrate {
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  GRKey key = grKeyFromBase64("bfpT8ZDjwCvnWkfPEYBm12q2p9srNkMf");

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String? encryptPassword(String password) {
    String encrypted = grEncrypt64Fernet(input: password, key: key);
    print(" encrypted Password : ${encrypted.toString()}");
    return encrypted;
  }

  String? decryptPassword(String input) {
    String decrypted = grDecrypt64Fernet(inputBase64: input, key: key);
    print("Password : ${decrypted.toString()}");
    return decrypted.toString();
  }
}
