import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText(
    this.text,
    this.icon, {
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.cover,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              TextSpan(text: text),
            ],
          ),
        ));
  }
}
