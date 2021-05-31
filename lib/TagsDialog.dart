import 'package:flutter/material.dart';

class TagsDialog extends StatefulWidget {
  final List<String> tags;

  const TagsDialog(this.tags, {Key key}) : super(key: key);

  @override
  _TagsDialogState createState() => _TagsDialogState(tags);
}

class _TagsDialogState extends State<TagsDialog> {
  List<String> tags;

  _TagsDialogState(this.tags);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tags"),
      content: Container(
        // TODO: add support of landscape screens
        width: MediaQuery.of(context).size.width / 1.2,
        child: ListView.separated(
          itemBuilder: _buildTiles,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: tags.length + 1,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, tags);
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  Widget _buildTiles(BuildContext context, int index) {
    if (tags.length == index) {
      return TextButton(
        // TODO: implement onPressed
        onPressed: () {},
        child: Text(
          "+ Add new tag",
        ),
      );
    } else {
      return ListTile(
        title: Text(
          tags[index],
        ),
      );
    }
  }
}

class TextEditorDialog extends StatefulWidget {
  const TextEditorDialog({Key key}) : super(key: key);

  @override
  _TextEditorDialogState createState() => _TextEditorDialogState();
}

class _TextEditorDialogState extends State<TextEditorDialog> {
  String tagName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text("Enter new tag"),
        content: TextField(
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            hintText: 'Tag',
          ),
          onChanged: (string) {
            tagName = string;
            setState(() {});
          },
          onSubmitted: save,
        ),
        actions: [
          TextButton(
            onPressed: () {
              save(tagName);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void save(String result) {
    Navigator.pop(context, result);
  }
}
