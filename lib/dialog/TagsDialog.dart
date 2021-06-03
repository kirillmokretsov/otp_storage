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
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return TagEditorDialog(null);
            },
          );
          if (result != null && result is String && result.isNotEmpty) {
            tags.add(result);
            setState(() {});
          }
        },
        child: Text(
          "+ Add new tag",
        ),
      );
    } else {
      // TODO: dismissible do not know about dialog borders
      return Dismissible(
        key: UniqueKey(),
        child: ListTile(
          title: Text(
            tags[index],
          ),
        ),
        background: Container(
          color: Colors.green,
          child: Icon(Icons.edit),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: Icon(Icons.delete),
        ),
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            tags.removeAt(index);
          } else if (direction == DismissDirection.startToEnd) {
            final result = await showDialog(
              context: context,
              builder: (BuildContext context) => TagEditorDialog(tags[index]),
            );
            if (result != null && result is String && result.isNotEmpty) {
              tags[index] = result;
            }
          }
          setState(() {});
        },
      );
    }
  }
}

class TagEditorDialog extends StatefulWidget {
  final String preEdited;

  const TagEditorDialog(this.preEdited, {Key key}) : super(key: key);

  @override
  _TagEditorDialogState createState() => _TagEditorDialogState(preEdited);
}

class _TagEditorDialogState extends State<TagEditorDialog> {
  String tagName;

  _TagEditorDialogState(this.tagName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text("Enter new tag"),
        content: TextFormField(
          initialValue: tagName,
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
          onFieldSubmitted: _save,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _save(tagName);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _save(String result) {
    Navigator.pop(context, result);
  }
}
