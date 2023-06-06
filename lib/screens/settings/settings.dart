import 'package:dart_wallet_v2/config/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  Map<int, String> networks = {
    0: dotenv.get('LOCAL_NETWORK'),
    1: dotenv.get('TEST_NETWORK'),
    2: dotenv.get('PROD_NETWORK')
  };

  Map<int, String> currencies = {
    0: dotenv.get('USD_CURRENCY'),
    1: dotenv.get('EUR_CURRENCY'),
    2: dotenv.get('CHF_CURRENCY')
  };

  late String selectedNetworkName;
  late String selectedCurrency;

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Networks',
          style: TextStyle(fontSize: 22),
        ),
        message: const Text('Please choose an active network',
            style: TextStyle(fontSize: 18)),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: Globals.instance.selectedNetwork == networks[0]!,
            onPressed: () {
              Globals.instance.selectedNetwork = networks[0]!;
              setState(() {
                selectedNetworkName = Globals.instance.selectedNetwork;
              });
              Navigator.pop(context);
            },
            child: const Text('Local'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Globals.instance.selectedNetwork == networks[1]!,
            onPressed: () {
              Globals.instance.selectedNetwork = networks[1]!;
              setState(() {
                selectedNetworkName = Globals.instance.selectedNetwork;
              });
              Navigator.pop(context);
            },
            child: const Text('Test'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Globals.instance.selectedNetwork == networks[2]!,
            onPressed: () {
              Globals.instance.selectedNetwork = networks[2]!;
              setState(() {
                selectedNetworkName = Globals.instance.selectedNetwork;
              });
              Navigator.pop(context);
            },
            child: const Text('Prod'),
          ),
        ],
      ),
    );
  }

  void _showActionSheetCurrency(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Currencies',
          style: TextStyle(fontSize: 22),
        ),
        message: const Text('Please choose a currency',
            style: TextStyle(fontSize: 18)),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: Globals.instance.selectedCurrency ==
                Globals.instance.currencyMapping[currencies[0]]!,
            onPressed: () {
              Globals.instance.selectedCurrency =
                  Globals.instance.currencyMapping[currencies[0]]!;
              setState(() {
                selectedCurrency = 'USD';
              });
              Navigator.pop(context);
            },
            child: const Text('USD'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Globals.instance.selectedCurrency ==
                Globals.instance.currencyMapping[currencies[1]]!,
            onPressed: () {
              Globals.instance.selectedCurrency =
                  Globals.instance.currencyMapping[currencies[1]]!;
              setState(() {
                selectedCurrency = 'EUR';
              });
              Navigator.pop(context);
            },
            child: const Text('EUR'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Globals.instance.selectedCurrency ==
                Globals.instance.currencyMapping[currencies[2]]!,
            onPressed: () {
              Globals.instance.selectedCurrency =
                  Globals.instance.currencyMapping[currencies[2]]!;
              setState(() {
                selectedCurrency = 'CHF';
              });
              Navigator.pop(context);
            },
            child: const Text('CHF'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider.value(
        value: Globals.instance,
        child: Consumer<Globals>(
            builder: (context, model, child) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: const Text('settings').tr(),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: CupertinoColors.label.resolveFrom(context),
                      fontSize: 22.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WalletUtils.renderQrImage(
                                  model.recoveryWords.isEmpty
                                      ? ''
                                      : model.recoveryWords)
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('networkSelect').tr(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            // Display a CupertinoPicker with list of fruits.
                            onPressed: () => _showActionSheet(context),
                            // This displays the selected fruit name.
                            child: Text(
                              selectedNetworkName[0].toUpperCase() +
                                  selectedNetworkName.substring(1),
                              style: const TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('currencySelect').tr(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            // Display a CupertinoPicker with list of fruits.
                            onPressed: () => _showActionSheetCurrency(context),
                            // This displays the selected fruit name.
                            child: Text(
                              selectedCurrency[0].toUpperCase() +
                                  selectedCurrency.substring(1),
                              style: const TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      selectedNetworkName = Globals.instance.selectedNetwork;
      selectedCurrency = Globals
          .instance.currencyMappingReverse[Globals.instance.selectedCurrency]!;
    });
    super.initState();
  }
}
