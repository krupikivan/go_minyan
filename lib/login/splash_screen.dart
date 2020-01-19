import 'package:flutter/material.dart';
import 'package:go_minyan/translation.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(Translations.of(context).splashText)),
    );
  }
}