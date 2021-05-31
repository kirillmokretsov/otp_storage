import 'package:flutter/material.dart';

class TagsDialog extends StatefulWidget {
  final List<String> tags;

  const TagsDialog(this.tags, {Key key}) : super(key: key);

  @override
  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  List<String> tags;

  _TagsDialogState(this.tags);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("View tags"),
      children: [
        ListView.separated(
          itemCount: tags.length + 1,
          itemBuilder: _buildTiles,
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Save"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTiles(BuildContext context, int index) {
    if (index == tags.length) {
      return ElevatedButton(
        onPressed: () {},
        child: Text("Add new tag"),
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
