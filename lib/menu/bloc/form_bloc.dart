import 'package:rxdart/rxdart.dart';

class FormBloc {

  //Este stream es para manejar si se envio el mail o no
  final _showProgress = BehaviorSubject<bool>();

  Observable<bool> get showProgress => _showProgress.stream;
  Function(bool) get changeProgress => _showProgress.sink.add;


  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();
  }
}

//Manejamos para traer los listados del cliente
final blocForm = FormBloc();