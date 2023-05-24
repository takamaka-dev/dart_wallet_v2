import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:flutter/cupertino.dart';

class ErrorSplashPage extends StatelessWidget {
  const ErrorSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
        child: Center(
            child: Column(
              children: [
                Icon(CupertinoIcons.hand_thumbsdown_fill, color: Styles.takamakaColor.withOpacity(0.9)),
                const SizedBox(height: 30),
                const Text("Transaction verification failed"),
                CupertinoButton(
                    color: Styles.takamakaColor,
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),

                    onPressed: () => {
                      Navigator.of(context).push(
                          CupertinoPageRoute<void>(builder: (BuildContext context) {
                            return const Home();
                          }))
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.home),
                        SizedBox(width: 10),
                        Text('Home'),
                      ],
                    ))
              ],
            )
        ),
      ),
    );
  }

}