import 'package:flutter/material.dart';
import 'package:go_minyan/administration_bloc/add_new_bloc.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';

List<WeekDays> weekDays = new List<WeekDays>();

class DropModelWidget extends StatefulWidget {

  final BuildContext context;

  const DropModelWidget({Key key, this.context}) : super(key: key);

  void _createDropDown() {
    weekDays.clear();
      weekDays.add(WeekDays(name: Translations.of(context).sunday, index: 0));
      weekDays.add(WeekDays(name: Translations.of(context).monday, index: 1));
      weekDays.add(WeekDays(name: Translations.of(context).tuesday, index: 2));
      weekDays.add(WeekDays(name: Translations.of(context).wednesday, index: 3));
      weekDays.add(WeekDays(name: Translations.of(context).thursday, index: 4));
      weekDays.add(WeekDays(name: Translations.of(context).friday, index: 5));
      weekDays.add(WeekDays(name: Translations.of(context).shabatTitle, index: 6));
  }

    @override
  _DropModelWidgetState createState() {
      _createDropDown();
      return _DropModelWidgetState();
    }
}

class _DropModelWidgetState extends State<DropModelWidget> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: blocAddNew.dropDay,
      builder: (context, snapshot) {
        return new DropdownButton(
          hint: Text(Translations.of(context).hintDDLabel),
          value: snapshot.data,
          onChanged: (newValue) => blocAddNew.changeDropDay(newValue),
          items: weekDays.map((value) {
            return new DropdownMenuItem(
              child: new Text(value.name),
              value: value.index,
            );
          }).toList(),
        );
      }
    );
  }
}
