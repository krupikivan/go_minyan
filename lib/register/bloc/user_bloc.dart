import 'package:rxdart/rxdart.dart';

class UserBloc {


  ///Es el que maneja si aparece el dialog que la carga fue exitosa
  final _showConfirmDialog = BehaviorSubject<bool>();

  ///Este stream es para manejar si se guardo o no
  final _showProgress = BehaviorSubject<bool>();

  Observable<bool> get outputConfirmDialog => _showConfirmDialog.stream;
  Function(bool) get inputConfirmDialog => _showConfirmDialog.sink.add;
//
  Observable<bool> get getProgress => _showProgress.stream;
  Function(bool) get addProgress => _showProgress.sink.add;


//  void test() {
//    _repository
//        .test()
//        .then((value) {
//    });
//  }

  void dispose() async {
    await _showConfirmDialog.drain();
    _showConfirmDialog.close();
    await _showProgress.drain();
    _showProgress.close();
  }
}

//Manejamos para traer los listados del cliente
final blocUser = UserBloc();