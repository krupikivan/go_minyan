import 'package:rxdart/rxdart.dart';

class TimePickerBloc {

  final _timePicker = BehaviorSubject<DateTime>();

  Observable<DateTime> get getTime => _timePicker.stream;
  Function(DateTime) get addTime => _timePicker.sink.add;

  void dispose() async {
    await _timePicker.drain();
    _timePicker.close();
  }
}

final blocTimePicker = TimePickerBloc();
