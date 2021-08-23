import 'package:flutter/material.dart';
import 'package:go_minyan/app.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/user_repository.dart';
import 'package:provider/provider.dart';
import 'style/bloc/theme_changer_bloc.dart';

///STEP 3

class ThemeDataWrapper extends StatelessWidget {
  final UserRepository _userRepository;

  ThemeDataWrapper({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
        builder: (_, model, child) =>
          model.darkmode == null ? Container() :
          ChangeNotifierProvider<ThemeChanger>(
            create: (_) =>
            model.darkmode
                ? ThemeChanger(ThemeData.dark())
                : ThemeChanger(ThemeData.light()),
            child: MyApp(userRepository: _userRepository, model: model),
          ),
    );
  }
}



