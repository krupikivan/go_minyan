import 'package:go_minyan/translation.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:intl/intl.dart';

class ConvertData{
  getWeekDayToString(num){
    switch(num){
      case 0:
        return FS.sunday;
        break;
      case 1:
        return FS.monday;
        break;
      case 2:
        return FS.tuesday;
        break;
      case 3:
        return FS.wednesday;
        break;
      case 4:
        return FS.thursday;
        break;
      case 5:
        return FS.friday;
        break;
      case 6:
        return FS.shabat;
        break;
    }
  }


  ///Hago la conversion del dia Firestore to Translation
  getTranslationFromFS(String firestore, context){
    switch(firestore){
      case FS.shajarit:
        return Translations.of(context).shajaritTitle;
        break;
      case FS.minja:
        return Translations.of(context).minjaTitle;
        break;
      case FS.arvit:
        return Translations.of(context).arvitTitle;
        break;
    }
  }

  getPrayFromInt(value){
    switch(value){
      case 0:
        return FS.shajarit;
        break;
      case 1:
        return FS.minja;
        break;
      case 2:
        return FS.arvit;
        break;
    }
  }

  timestampToString(int data){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(data);
    return DateFormat("HH:mm").format(date);
  }

  //TimeOfDay to DateTime
  DateTime getDateTime(time){
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

}

final convertData = ConvertData();