import 'package:flutter/material.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/widget/widget.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String text;
  final size;

  LoginButton({Key key, VoidCallback onPressed, this.text, this.size})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      splashColor: Theme.Colors.secondaryColor,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: TextModel(
        text: text,
        size: 18,
        color: Colors.white,
      ),
      onPressed: _onPressed,
    );
  }
}
