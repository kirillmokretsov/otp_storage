import 'package:flutter/material.dart';

// TODO: allow delete tags
// TODO: allow edit tags

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
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TextEditorDialog('');
            },
          );
        },
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
  final String preEdited;

  const TextEditorDialog(this.preEdited, {Key key}) : super(key: key);

  @override
  _TextEditorDialogState createState() => _TextEditorDialogState(preEdited);
}

class _TextEditorDialogState extends State<TextEditorDialog> {
  String tagName;
  bool insertedOld = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (insertedOld == false) {
        _controller.value = TextEditingValue(
          text: tagName,
        );
        insertedOld = true;
      } else {
        tagName = _controller.text;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _TextEditorDialogState(this.tagName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text("Enter new tag"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            hintText: 'Tag',
          ),
          onChanged: (string) {
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
