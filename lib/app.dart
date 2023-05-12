import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/providers/session_provider.dart';
import 'package:dart_wallet_v2/repositories/wallet_repo.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:dart_wallet_v2/repositories/wallet_repo_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/screens/splash/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final State<Splash> splashState;

  const App(this.splashState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Wallet',
      initialRoute: Splash.routeName,
      home: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitCubeGrid(
            color: Styles.primaryHighlightColor,
            size: 80.0,
          ),
        ),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        child: Splash(splashState),
      ),
      /*routes: {Splash.routeName: (context) => Splash(splashState)},*/
    );
  }
}

/// Performs initialization steps and then runs our app.
Future<void> runAppWithOptions(
    {String envFileName = '.env',
    required State<Splash> splashState}) async {
  flutter.WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: envFileName);

  flutter.runApp(
    ChangeNotifierProvider.value(
        value: SessionProvider(Globals.instance),
        child: App(splashState))
  );
}
