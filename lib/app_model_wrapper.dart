import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/theme_data_wrapper.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:provider/provider.dart';

import 'authentication_bloc/authentication_event.dart';

///STEP 2

class AppModelWrapper extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  ///User preferences instance
  final AppModel _appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    /// Initialize User preferences
    _appModel.initializeValues();
    //Actualizamos los markers, si existen los borramos y luego se cargan
//    _appModel.getMarkersData();
//    _appModel.removeMarkerTempData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _appModel),
//    ChangeNotifierProvider<PushProvider>(create: (_) => PushProvider(null))
      ],
      child: BlocProvider(
        builder: (context) => AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted()),
        child: ThemeDataWrapper(userRepository: userRepository),
      ),
    );
  }
}
