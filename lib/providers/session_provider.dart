import 'package:dart_wallet_v2/config/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SessionProvider extends ChangeNotifier {
  Globals globals;

  SessionProvider(this.globals);
}
