import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_minyan/app_model_wrapper.dart';
import 'package:go_minyan/simple_bloc_delegate.dart';

///STEP 1
void main() {
  //Me soluciono un error que no tengo idea porque, pero el error vino despues de hacer Flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(new AppModelWrapper());
}

