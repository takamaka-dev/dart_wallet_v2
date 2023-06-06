import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/error.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/styles.dart';

class BlobFile extends StatefulWidget {
  const BlobFile({super.key});

  @override
  State<StatefulWidget> createState() => _BlobFileState();
}

class _BlobFileState extends State<BlobFile> {
  List<String> tags = [];

  File? _selectedFile;

  late List<String> availableMetadata = [];

  final TextEditingController _tagController = TextEditingController();

  num get maxFileDimension => 5242880; //5MB

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File selectedFile = File(result.files.single.path!);

      Globals.instance.tkmMetaData =
          await MetadataUtils.collectMetadata(selectedFile, tags);

      Map<String, dynamic>? metaDatas =
          Globals.instance.tkmMetaData.extraMetadata;

      if (int.parse(Globals.instance.tkmMetaData.extraMetadata!['FileSize']) >
          maxFileDimension) {
        Navigator.of(context).restorablePush(_dialogBuilderAlertFileSize);
      }

      metaDatas?.forEach((key, value) {
        if (value != null && value != "") {
          availableMetadata.add("$key - " +
              (key != 'FileSize' ? value : value.toString() + ' Byte'));
        }
      });

      setState(() {
        _selectedFile = selectedFile;
        availableMetadata = availableMetadata;
      });
    }
  }

  FeeBean currentFeeBean = FeeBean();
  late TransactionInput ti;

  Future<bool> _initBlobInterface() async {
    setState(() {
      _selectedFile = null;
    });

    return true;
  }

  void updateTagsList(String value) {
    if (value.isNotEmpty) {
      setState(() {
        tags.add(value);
      });
    } else {
      setState(() {});
    }
    _tagController.text = "";
  }

  @override
  void initState() {
    _initBlobInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> doBlob() async {
    context.loaderOverlay.show();

    String message = jsonEncode(Globals.instance.tkmMetaData.toJson());

    InternalTransactionBean itb = BuilderItb.blob(
        Globals.instance.selectedFromAddress,
        message,
        TKmTK.getTransactionTime());

    SimpleKeyPair skp =
        await WalletUtils.getNewKeypairED25519(Globals.instance.generatedSeed);

    TransactionBean tb = await TkmWallet.createGenericTransaction(
        itb, skp, Globals.instance.selectedFromAddress);

    String tbJson = jsonEncode(tb.toJson());
    String payHexBody = StringUtilities.convertToHex(tbJson);

    ti = TransactionInput(payHexBody);

    Globals.instance.ti = ti;

    TransactionBox payTbox =
        await TkmWallet.verifyTransactionIntegrity(tbJson, skp);

    String? singleInclusionTransactionHash =
        payTbox.singleInclusionTransactionHash;

    Globals.instance.sith = singleInclusionTransactionHash!;

    FeeBean feeBean = TransactionFeeCalculator.getFeeBean(payTbox);

    Globals.instance.feeBean = feeBean;

    context.loaderOverlay.hide();

    if (feeBean.disk != null) {
      Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
    }
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderAlertFileSize(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: const Text('fileSizeLimit').tr(),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ok').tr(),
            ),
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderPreConfirm(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('trxCost').tr(),
              Text('${'disk'.tr()}${' ${Globals.instance.feeBean.disk},'
                  'mem'.tr()} ${Globals.instance.feeBean.memory},${'cpu'.tr()} ${Globals.instance.feeBean.cpu}')
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('abort').tr(),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                context.loaderOverlay.show();
                final response = await ConsumerHelper.doRequest(
                    HttpMethods.POST,
                    ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!,
                    Globals.instance.ti.toJson());
                if (response == '{"TxIsVerified":"true"}') {
                  context.loaderOverlay.hide();
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                    return SuccessSplashPage(Globals.instance.sith);
                  }));
                } else {
                  context.loaderOverlay.hide();
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                    return const ErrorSplashPage();
                  }));
                }
              },
              child: const Text('confirm').tr(),
            )
          ],
        );
      },
    );
  }

  void deleteTag(String tag) {
    setState(() {
      tags.removeWhere((element) => element == tag);
    });
  }

  void deleteMetaData(String metaData) {
    Map<String, dynamic>? emt = {};

    Globals.instance.tkmMetaData.extraMetadata?.forEach((key, value) {
      String splittedMetaTagWithKey = metaData.split(" - ")[0];
      if (key != splittedMetaTagWithKey) {
        emt.putIfAbsent(key, () => value);
      }
    });

    Globals.instance.tkmMetaData.extraMetadata = emt;

    setState(() {
      availableMetadata.removeWhere((element) => element == metaData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
                color: Styles.takamakaColor,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Navigate back when back button is pressed
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("uploadFileBinary",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))
                            .tr()
                            .tr(),
                      ],
                    ),
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
            child: Column(
              children: [
                CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: _openFilePicker,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.doc_fill),
                          const SizedBox(width: 10),
                          const Text('selectFile').tr()
                        ])),
                const SizedBox(height: 16),
                _selectedFile != null
                    ? Row(
                        children: [
                          const Text('selectedFile').tr(),
                          Text(_selectedFile!.path)
                        ],
                      )
                    : const Text('noFileSelected').tr(),
                const SizedBox(height: 10),
                TagList(
                    availableMetadata,
                    Colors.black45,
                    MainAxisAlignment.center,
                    Colors.grey.shade300,
                    Colors.red.shade300,
                    deleteMetaData,
                    false),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: CupertinoTextField(
                        placeholder: "words".tr(),
                        onSubmitted: (String value) => {updateTagsList(value)},
                        controller: _tagController,
                        onChanged: (value) => {},
                      ),
                    ),
                    CupertinoButton(
                        child: const Icon(CupertinoIcons.plus),
                        onPressed: () => {updateTagsList(_tagController.text)})
                  ],
                ),
                const SizedBox(height: 10),
                TagList(
                    tags,
                    Colors.white,
                    MainAxisAlignment.spaceBetween,
                    Styles.takamakaColor.withOpacity(0.9),
                    Colors.red.shade300,
                    deleteTag,
                    false),
                const SizedBox(height: 30),
                CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: () => {doBlob()},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.paperplane),
                          const SizedBox(width: 10),
                          const Text('send').tr()
                        ])),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
