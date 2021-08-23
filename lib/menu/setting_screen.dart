import 'package:flutter/material.dart';
import 'package:go_minyan/style/bloc/theme_changer_bloc.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:go_minyan/widget/dropdown_setting.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);
    bool darkmode = Provider.of<AppModel>(context).darkmode;
    return Consumer<AppModel>(
      builder: (context, model, child) =>  Scaffold(
          appBar: AppBar(
            backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
            title: Text(Translations.of(context).settings),
            actions: <Widget>[
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: <Widget>[
                TextModel(text: Translations.of(context).displayTitle, size: 20, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor, fontWeight: FontWeight.bold),
                ListTile(
                  title: Text(Translations.of(context).darkMode),
                  trailing: Switch(
                    activeColor: Theme.Colors.primaryColor,
                    value: model.darkmode,
                    onChanged: (val) {
                        model.setTheme(val);
                      if (model.darkmode) {
                        theme.setTheme(ThemeData.dark());
                      } else {
                        theme.setTheme(ThemeData.light());
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Text(Translations.of(context).language),
                  subtitle: TextModel(text: Translations.of(context).languageContent, color: Theme.Colors.hintDarkColor),
                  trailing: CustomDropdownButton(
                    value: model.language,
                    items: model.langList,
                    onChanged: model.setLanguage,
                  ),
                ),
                Divider(indent: 10,),
                TextModel(text: Translations.of(context).notification, size: 20, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor, fontWeight: FontWeight.bold),
                ListTile(
                  title: Text(Translations.of(context).notificationReminder),
                  trailing: CustomDropdownButton(
                    value: model.reminder,
                    items: model.getReminderList(Translations.of(context).minutesBefore),
                    onChanged: model.setReminder,
                  ),
                ),
                Divider(indent: 10,),
                TextModel(text: Translations.of(context).map, size: 20, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor, fontWeight: FontWeight.bold),
                ListTile(
                  title: Text(Translations.of(context).updateMapData),
                  trailing: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18),
                        side: BorderSide(color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor)
                      ),
                      onPressed: () => restoreDataMap(context), child: TextModel(text: Translations.of(context).update)),
                ),
                Divider(indent: 10,),
              ],
            ),
          )
      ),
    );
  }

  restoreDataMap(context){
    Provider.of<AppModel>(context).removeForUpdate();
    ShowToast().show(Translations.of(context).updating, 10);
  }



}
