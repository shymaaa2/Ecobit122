import 'package:encrypt/encrypt.dart';

class Encryption {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8('E4rqzxa37VCwz7I/enrUy1SxwH6BRo0M'), padding: 'PKCS7'));

    Encrypted encrypted(String plainTxt){
      final encrypted = encrypter.encrypt(plainTxt, iv: iv);
      return encrypted;
    }

    String decrypted(String crypTxt){
      final parts = crypTxt.split(':');
      final decrypted = encrypter.decrypt(Encrypted.fromBase64(parts[1]), iv: iv);
      return decrypted;
    }
}

