import 'package:flutter/rendering.dart';

import 'app.dart';
import '/screens/splash/splash_state.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  runAppWithOptions(
    envFileName: '.env',
    splashState: SplashState(),
  );
}
