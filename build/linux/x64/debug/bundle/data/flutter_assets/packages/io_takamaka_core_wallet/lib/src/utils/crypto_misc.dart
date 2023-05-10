import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:hex/hex.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:sha3/sha3.dart';

/// these methods use several external packages such as hex and crypto.
/// The hex package provides functions for encoding and decoding hexadecimal strings,
/// while the crypto package provides cryptographic functions for hashing and key derivation.
/// These packages provide basic cryptographic capabilities for Flutter applications.
class CryptoMisc {

  static const int dictionaryAllLength = 2048;
  static const int wordsLength = 25;
  static const String walletKeyChain = "__WKCH__";

  /// This method takes a string input, converts it to bytes using UTF-8 encoding, computes the SHA3-256 hash of the bytes, and returns the hash value as a hexadecimal string.
  static String hash256ToHex(String input) {
    List<int> bytes = utf8.encode(input);
    String hexVersion = hex.encode(bytes);
    var k = SHA3(256, SHA3_PADDING, 256);
    k.update(bytes);
    var hash = k.digest();
    hexVersion = HEX.encode(hash);
    return hexVersion;
  }

  /// This method takes a string input, a salt string salt, an integer iterations for the number of iterations of the PBKDF2 algorithm, and an integer bitLengthKey for the bit length of the derived key. It then uses the PBKDF2 algorithm with HMAC-SHA512 as the MAC algorithm to derive a key from the input and salt strings. The derived key is returned as a list of integers.
  static Future<List<int>> pwHash(String input, String salt, int iterations,
      int bitLengthKey) async {
    final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha512(),
        iterations: iterations,
        bits: bitLengthKey
    );

    // Password we want to hash
    final secretKey = SecretKey(utf8.encode(input));

    // A random salt
    final nonce = utf8.encode(salt);

    // Calculate a hash that can be stored in the database
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: nonce,
    );
    final newSecretKeyBytes = await newSecretKey.extractBytes();
    return newSecretKeyBytes;
  }

  static Future<String> signAndVerify(SimpleKeyPair keyPair, String message) async{

    final algorithm = DartEd25519(sha512: Sha512());

    Signature unsignedSignature = await algorithm.signString(
      message,
      keyPair: keyPair,
    );
    // String encoded = "0x${hex.encode(unsignedSignature.bytes)}";
    // var bi = BigInt.parse(encoded);
    // List<int> signature = List.filled((bi.bitLength / 8).ceil(), 0);
    // for (int i = 0; i < signature.length; i++) {
    //   signature[i] = (bi >> (i * 8)).toSigned(8).toInt();
    // }

    final isSignatureCorrect = await algorithm.verifyString(
      message,
      signature: unsignedSignature,
    );

    if(isSignatureCorrect){

      var base64Sig = base64.encode(unsignedSignature.bytes);
      
      var base64UrlSafeSig = StringUtilities.convertFromBase64ToBase64UrlSafe(base64Sig);
      
      return base64UrlSafeSig;
      //return hex.encode(signature.bytes);
    }else{
      throw Error();
    }

  }
}