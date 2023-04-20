import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart' as globals;

class WalletGeneralUtils {
  static Future<void> saveSeed() async {
    String seed = await WalletUtils.generateSeedPWH(globals.words);

    FileSystemUtils.saveFile(dotenv.get('SEED_FILE_NAME'), seed).then((value) => {
      if (value) {
        globals.generatedSeed = seed
      }
    });
  }
}