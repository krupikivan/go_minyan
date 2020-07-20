import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/login/login.dart';
import 'package:go_minyan/menu/menu.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/login/splash_screen.dart';
import 'package:go_minyan/style/bloc/theme_changer_bloc.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'administration/admin.dart';
import 'authentication_bloc/authentication_state.dart';
import 'register/register.dart';

///STEP 4

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final AppModel model;

  MyApp({Key key, @required UserRepository userRepository, this.model})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  bool _isAdmin(user, data) {
    for (int i = 0; i < data[FS.userUID].length; i++) {
      if (data[FS.userUID][i] == user) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: blocUserData.getUserAdmin(),
        builder: (context, userAdmin) {
          return MaterialApp(
            locale: model.appLocal,
            localizationsDelegates: [
              const TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('es', ''), // Spanish
              const Locale('en', ''), // English
              const Locale('he', ''), // Hebrew
            ],
            debugShowCheckedModeBanner: false,
            title: 'MinianLogin',
            theme: theme.getTheme(),
            initialRoute: '/',
            routes: {
              '/minian': (context) => MinianScreen(),
              '/info': (context) => AboutScreen(),
              '/menu': (context) => MenuScreen(),
            },
            home: Consumer<AppModel>(
              builder: (_, appModel, child) =>
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  // if (state is Guest || state is AuthBack) {
                  //   return MenuScreen();
                  // }
                  if (state is ChangePassScreen) {
                    return ChangePassword();
                  }
                  if (state is Register) {
                    return RegisterScreen();
                  }
                  if (state is Unauthenticated) {
                    return LoginScreen(userRepository: _userRepository);
                  }
                  if (state is Authenticated || state is AuthBack) {
                    return MenuScreen();
                  }
                  if (state is AdminPanel) {
                    if (_isAdmin(state.userUID, userAdmin.data)) {
                      return RootScreen();
                    } else {
                      //Get data from shared preferences
                      appModel.getNusachList();
                      appModel.getUserData();
                      appModel.getScheduleData();
                      return AdminScreen(
                          username: state.displayName, userUID: state.userUID);
                    }
                  }
                  return SplashScreen();
                },
              ),
            ),
          );
        });
  }
}
