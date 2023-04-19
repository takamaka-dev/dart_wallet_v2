import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatelessWidget {
  const QrCode(this.qrinput, {super.key});

  final String qrinput;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: QrImage(
            data: qrinput,
            size: 280,
            // You can include embeddedImageStyle Property if you
            //wanna embed an image from your Asset folder
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(
                100,
                100,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
