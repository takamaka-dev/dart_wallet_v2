import 'package:dart_wallet_v2/config/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:provider/provider.dart';

const double _kItemExtent = 32.0;
const List<String> _networkNames = <String>['Local', 'Test', 'Production'];

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  final int _selectedNetwork = 0;
  Map<int, String> networks = {
    0: dotenv.get('LOCAL_NETWORK'),
    1: dotenv.get('TEST_NETWORK'),
    2: dotenv.get('PROD_NETWORK')
  };

  late String selectedNetworkName;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider.value(
        value: Globals.instance,
        child: Consumer<Globals>(
            builder: (context, model, child) => CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                middle: Text('Settings'),
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
                      SizedBox(height: 80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WalletUtils.renderQrImage(
                              model.recoveryWords.isEmpty
                                  ? ''
                                  : model.recoveryWords)
                        ],
                      ),
                      const Text('Selected network: '),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        // Display a CupertinoPicker with list of fruits.
                        onPressed: () => _showActionSheet(context),
                        /*_showDialog(
                            CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  Globals.instance.selectedNetwork = networks[selectedItem]!;
                                  print(Globals.instance.selectedNetwork);
                                });
                              },
                              children: List<Widget>.generate(
                                  _networkNames.length, (int index) {
                                return Center(
                                  child: Text(
                                    _networkNames[index],
                                  ),
                                );
                              }),
                            ),
                          ),*/
                        // This displays the selected fruit name.
                        child: Text(
                          selectedNetworkName[0].toUpperCase() +
                              selectedNetworkName.substring(1),
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
    });
    super.initState();
  }
}
