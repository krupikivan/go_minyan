import 'package:go_minyan/model/model.dart';
import 'package:rxdart/rxdart.dart';

//Clase que maneja el stream de las push notification
class PushBloc {

  //To listen documents collection
  final _pushNotification = BehaviorSubject<PushData>();
  Observable<PushData> get pushNotification => _pushNotification.stream;

  //To listen documents data
  Observable<PushData> get readPush => _pushNotification.stream;
  Function(PushData) get addPush => _pushNotification.sink.add;

  changeFlag(value){
    _pushNotification.listen((pushData){
      pushData.wasPushed != value ? pushData.wasPushed = value : null;
    });
  }

  void dispose() async {
    await _pushNotification.drain();
    _pushNotification.close();
  }
}

//Manejamos para traer los listados del cliente
final blocPush = PushBloc();