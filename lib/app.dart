import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/providers/session_provider.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/screens/splash/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class App extends StatelessWidget {
  final State<Splash> splashState;

  const App(this.splashState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Globals.instance.selectedNetwork.isEmpty) {
      Globals.instance.selectedNetwork = dotenv.get('FORCE_NETWORK');
    }
    if (Globals.instance.selectedCurrency < 0) {
      Globals.instance.selectedCurrency =
          Globals.instance.currencyMapping[dotenv.get('FORCE_CURRENCY')]!;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Wallet',
      initialRoute: Splash.routeName,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
            child:
                CircularProgressIndicator()
            ),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        child: Splash(splashState),
      ),
    );
  }
}

/// Performs initialization steps and then runs our app.
Future<void> runAppWithOptions(
    {String envFileName = '.env', required State<Splash> splashState}) async {
  flutter.WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: envFileName);

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  flutter.runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('it')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ChangeNotifierProvider.value(
            value: SessionProvider(Globals.instance), child: App(splashState))),
  );
}
