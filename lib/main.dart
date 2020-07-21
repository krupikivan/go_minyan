import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_minyan/app_model_wrapper.dart';
import 'package:go_minyan/simple_bloc_delegate.dart';

import 'model/app_model.dart';

///STEP 1
void main() async {
  //Me soluciono un error que no tengo idea porque, pero el error vino despues de hacer Flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final prefs = new AppModel();
  await prefs.initPrefs();
  runApp(new AppModelWrapper());
}
