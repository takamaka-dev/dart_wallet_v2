import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void VoidCallback(String tag);

class TagList extends StatefulWidget {
  TagList(this.tags, this.tagTextColor, this.tagAlignment, this.tagsBrickColor,
      this.deleteButtonColor, this.vcaDelete, {super.key});

  MainAxisAlignment tagAlignment;
  Color tagsBrickColor;
  Color deleteButtonColor;
  Color tagTextColor;
  List<String> tags;
  VoidCallback vcaDelete;

  @override
  State<StatefulWidget> createState() =>
      _TagListState(
          tags,
          tagTextColor,
          tagAlignment,
          tagsBrickColor,
          deleteButtonColor,
          vcaDelete
      );
}

class _TagListState extends State<TagList> {

  _TagListState(this.tags, this.tagTextColor, this.tagAlignment,
      this.tagsBrickColor, this.deleteButtonColor, this.vcaDelete);

  Color tagsBrickColor;
  Color deleteButtonColor;
  Color tagTextColor;
  MainAxisAlignment tagAlignment;
  List<String> tags;
  VoidCallback vcaDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Wrap(
        spacing: 8.0, // Spazio tra gli elementi
        runSpacing: 8.0,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(tags.length, (index) {
          return renderSingleTag(tags[index], index);
        }),
      ),
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogEditTag(BuildContext context,
      Object? arguments) {

    TextEditingController tagController = TextEditingController(text: Globals.instance.editTagValue);

    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Edit tag'),
          content: CupertinoTextField(
            controller: tagController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abort'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Globals.instance.editTagValue = tagController.text;
                Globals.instance.restoreNewWalletsWords[Globals.instance.editTagIndex] = tagController.text;
                Globals.instance.restoreNewWalletsWords = Globals.instance.restoreNewWalletsWords;
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  Widget renderSingleTag(String tag, index) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      width: tag.length <= 5 ? tag.length == 1 ? tag.length * 80 : tag.length *
          45 : tag.length * 25,
      child: CupertinoButton(
          color: tagsBrickColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
          borderRadius: BorderRadius.zero,
          onPressed: () async => {
            Globals.instance.editTagIndex = index,
            Globals.instance.editTagValue = tag,
            Navigator.of(context).restorablePush(_dialogEditTag)
      },
          child: Row(
            mainAxisAlignment: tagAlignment,
            children: [
              Expanded(child: Text(
                  "${index + 1} - $tag", textAlign: TextAlign.center,
                  style: TextStyle(color: tagTextColor))),
              deleteButtonColor.value != 0 ? RawMaterialButton(
                  elevation: 2.0,
                  fillColor: deleteButtonColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                  ),
                  constraints: const BoxConstraints.tightFor(
                    width: 40.0,
                    height: 40.0,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                  {
                    vcaDelete(tag)
                  }) : const Text("")
            ],
          )),
    );
  }

}
