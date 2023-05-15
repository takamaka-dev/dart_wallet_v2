import 'package:flutter/rendering.dart';

import 'app.dart';
import '/screens/splash/splash_state.dart';

void main() {
  debugPaintSizeEnabled = false;
  runAppWithOptions(
      envFileName: '.env',
      splashState: SplashState(),
  );
}