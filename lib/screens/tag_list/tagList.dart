import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void VoidCallback(String tag);

class TagList extends StatefulWidget {
  TagList(this.tags, this.tagTextColor, this.tagAlignment, this.tagsBrickColor, this.deleteButtonColor, this.vcaDelete, {super.key});

  MainAxisAlignment tagAlignment;
  Color tagsBrickColor;
  Color deleteButtonColor;
  Color tagTextColor;
  List<String> tags;
  VoidCallback vcaDelete;

  @override
  State<StatefulWidget> createState() => _TagListState(
      tags,
      tagTextColor,
      tagAlignment,
      tagsBrickColor,
      deleteButtonColor,
      vcaDelete
  );
}

class _TagListState extends State<TagList> {

  _TagListState(this.tags, this.tagTextColor, this.tagAlignment, this.tagsBrickColor, this.deleteButtonColor, this.vcaDelete);

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
          return renderSingleTag(tags[index]);
        }),
      ),
    );
  }

  Widget renderSingleTag(String tag) {
    return SizedBox(
      height: 50,
      width: 300,
      //width: cellwidth

      child: CupertinoButton(
          color: tagsBrickColor,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
          borderRadius: BorderRadius.zero,
          onPressed: () => {},
          child: Row(
            mainAxisAlignment: tagAlignment,
            children: [
              Expanded(child: Text(tag, style: TextStyle(color: tagTextColor))),
              RawMaterialButton(
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
                  onPressed: () => {
                    vcaDelete(tag)
                  })
            ],
          )),
    );
  }

}
