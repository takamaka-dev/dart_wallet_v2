import 'package:dart_wallet_v2/repositories/wallet_repo_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SessionProvider extends ChangeNotifier {
  WalletRepoInterface walletRepo;

  SessionProvider(this.walletRepo);


}
