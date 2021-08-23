import 'package:flutter/material.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

class SearchMap extends StatelessWidget {

  final TextEditingController searchController;
  final bool darkmode;

  const SearchMap({Key key, this.searchController, this.darkmode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 300,
        height: 70,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 17),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              size: 24,
                color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: searchController,
                  enabled: true,
                  cursorColor: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,
                  decoration: InputDecoration(
                    hintText: Translations.of(context).searchTitle,
                    hintStyle: TextStyle(color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor),
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: (){searchController.clear();},
                color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.blackColor
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(36)),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 36),
            ]),
      ),
    );
  }
}
