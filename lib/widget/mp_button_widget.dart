import 'package:flutter/material.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/widget/text_model.dart';

class MPButtonWidget extends StatelessWidget {

  final VoidCallback _onPressed;
  final String text;
  final size;
  final darkmode;

  MPButtonWidget({Key key, VoidCallback onPressed, this.text, this.size, this.darkmode})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      splashColor: Theme.Colors.secondaryColor,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01),
        child: TextModel(text: text, size: 20, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,
        ),
      ),
      onPressed: _onPressed,
    );
  }
}
