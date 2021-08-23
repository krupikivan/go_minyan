import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_minyan/style/theme.dart' as Theme;


class ShowToast{

  show(String msg, time){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: time,
        backgroundColor: Theme.Colors.secondaryColor
    );
  }

}