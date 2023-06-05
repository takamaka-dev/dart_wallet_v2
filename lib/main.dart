import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import '/screens/splash/splash_state.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  runAppWithOptions(
      envFileName: '.env',
      splashState: SplashState(),
  );
}