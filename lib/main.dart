import 'app.dart';
import '/screens/splash/splash_state.dart';

void main() {
  runAppWithOptions(
      envFileName: '.env',
      splashState: SplashState(),

  );
}