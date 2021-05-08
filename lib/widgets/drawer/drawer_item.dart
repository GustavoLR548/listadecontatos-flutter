import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Text title;
  final Icon icon;
  final Function? onTap;

  final defaultColor = Colors.amber;

  const DrawerItem(
      {this.title = const Text('Null'),
      this.icon = const Icon(Icons.crop),
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: this.icon,
        title: this.title,
        onTap: () {
          if (this.onTap == null) return;

          this.onTap!();
        });
  }
}
