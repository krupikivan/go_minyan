import 'package:flutter/material.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

class TextModel extends StatelessWidget {

  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  final TextDecoration decoration;

  const TextModel({Key key, this.text, this.color, this.size, this.fontWeight, this.decoration}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          decoration: decoration,
          fontFamily: Theme.Fonts.primaryFont,
          color: color),
    );
  }
}
