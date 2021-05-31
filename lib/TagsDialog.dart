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
          itemCount: tags.length,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {},
          child: Text("Save"),
        ),
      ],
    );
  }

  Widget _buildTiles(BuildContext context, int index) {
    return ListTile(
      title: Text(
        tags[index],
      ),
    );
  }
}
