import 'package:flutter/material.dart';
import 'package:go_minyan/administration_bloc/bloc.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

// ignore: must_be_immutable
class RadioModelWidget extends StatefulWidget {

  bool darkmode;

  final String sha;
  final String min;
  final String arv;

  RadioModelWidget({Key key, this.darkmode, this.sha, this.min, this.arv}) : super(key: key);
   @override
  _RadioModelWidgetState createState() => _RadioModelWidgetState();
}

class _RadioModelWidgetState extends State<RadioModelWidget> {
  List<RadioModel> sampleData = new List<RadioModel>();


  @override
  void initState() {
    super.initState();
    setRadioData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          highlightColor: Theme.Colors.primaryColor,
          splashColor: Theme.Colors.primaryColor,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
              blocAddNew.changeRadioPray(sampleData[index].value);
            });
          },
          child: new RadioItem(sampleData[index], widget.darkmode),
        );
      },
    );
  }

  void setRadioData() {
      sampleData.add(new RadioModel(true, widget.sha, 0));
      sampleData.add(new RadioModel(false, widget.min, 1));
      sampleData.add(new RadioModel(false, widget.arv, 2));
      blocAddNew.changeRadioPray(sampleData[0].value);
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  final darkmode;
  RadioItem(this._item, this.darkmode);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 20.0,
            width: 20.0,
            color: _item.isSelected ? darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor : Theme.Colors.secondaryColor,
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;
  final int value;

  RadioModel(this.isSelected, this.text, this.value);
}