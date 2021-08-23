import 'package:flutter/material.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String name;
  final bool darkmode;

  RegisterButton({Key key, VoidCallback onPressed, this.name, this.darkmode})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Theme.Colors.secondaryColor,
      splashColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text(name),
    );
  }
}