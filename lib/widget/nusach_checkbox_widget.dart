import 'package:flutter/material.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class NusachCheckWidget extends StatefulWidget {

  bool darkmode;
  NusachCheckWidget({Key key, this.darkmode, this.size}) : super(key: key);
  final size;

    @override
  _NusachCheckWidgetState createState() {
      return _NusachCheckWidgetState();
    }
}

class _NusachCheckWidgetState extends State<NusachCheckWidget> {


    @override
  Widget build(BuildContext context) {
      widget.darkmode = Provider.of<AppModel>(context).darkmode;
      return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          _chooseNusach();
        },
        color: widget.darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
        textColor: Theme.Colors.secondaryColor,
        child: Text(Translations.of(context).btnNusach),
      );
    }

  _chooseNusach () {
    Alert(
        context: context,
        title: Translations.of(context).btnNusach,
        style: AlertStyle(titleStyle: TextStyle(
          color: widget.darkmode ? Theme.Colors.whiteColor : Theme.Colors.primaryColor,
        )),
        content: Container(
          width: double.maxFinite,
          height: MediaQuery
              .of(context)
              .size
              .height / 2.2,
          child: StreamBuilder<List<String>>(
              stream: blocNusach.listenNusach,
              builder: (context, allNusach) {
                if(!allNusach.hasData){return Container();}
                else
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: allNusach.data.length,
                      itemBuilder: (BuildContext context, int index){
                        String name = allNusach.data[index];
                        ///Get user saved nusach from firebase
                        return StreamBuilder<UserData>(
                          stream: blocUserData.getUserData,
                          builder: (context, userNusach) {
                            if(!userNusach.hasData){return Container();}
                            else
                              //Revisamos que nuestro bloc contenga o no lo que esta en firestore
                              //Para saber si el checkbox seteamos false o true
                            if(userNusach.data.nusach.contains(allNusach.data[index])){
                              return _buildCheckBox(name, true, userNusach.data);
                            }
                            else{
                              return _buildCheckBox(name, false, userNusach.data);
                            }
                          }
                        );
                      }
                  );
              }
          ),
        ),
        buttons: [
          DialogButton(
            color: widget.darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextModel(text: Translations.of(context).btnAccept, color: Theme.Colors.secondaryColor, size: 20
            ),
          )
        ]).show();
  }

  Widget _buildCheckBox(name, value, UserData data){
    return ListTile(
      title: Text(name),
      trailing: Checkbox(
          activeColor: widget.darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
          value: value,
          onChanged: (bool value) {
            _changeCheckBox(name, value, data);
          }
      ),
    );
  }

  void _changeCheckBox(name, bool value, UserData data){
      //Si deselecciono el check entonces elimino de la lista el elemento y lo cargo en el bloc
    //Soluciona lo de cannot remove fix length list
    var tempOutput = new List<String>.from(data.nusach);
    if(!value){
        tempOutput.remove(name);
        data.nusach = tempOutput;
        blocUserData.changeUserData(data);
      }
      else {
        tempOutput.add(name);
        data.nusach = tempOutput;
        blocUserData.changeUserData(data);
      }
  }
  }
