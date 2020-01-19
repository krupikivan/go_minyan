import 'package:rxdart/rxdart.dart';


class AddNewBloc {

  final _dropDay = BehaviorSubject<int>();

  //Manejo el value 0-Shajarit, 1-Minja, 2-Arvit
  final _radioPray = BehaviorSubject<int>();

  Observable<int> get dropDay => _dropDay.stream;
  Observable<int> get radioPray => _radioPray.stream;

  Function(int) get changeDropDay => _dropDay.sink.add;
  Function(int) get changeRadioPray => _radioPray.sink.add;


  void dispose() async {
    await _dropDay.drain();
    _dropDay.close();
    await _radioPray.drain();
    _radioPray.close();
  }
}

final blocAddNew = AddNewBloc();
