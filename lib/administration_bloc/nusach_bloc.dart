import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_minyan/resources/repository.dart';

class NusachBloc {

  List<String> _nusachList = List();

  final _repo = Repository();
  final _nusach = BehaviorSubject<List<String>>();

  Observable<List<String>> get listenNusach => _nusach.stream;
  Function(List<String>) get addNusach => _nusach.sink.add;


  //Get all nusach from firestore
  _getNusachFromFirebase(AppModel appModel) {
    _repo.getNusachList().listen((snapshot) {
      for(DocumentSnapshot doc in snapshot.documents){
        _nusachList.add(doc[FS.nusach]);
      }
      addNusach(_nusachList);
      appModel.setNusachList(_nusachList);
    });
  }

  //Get all nusach from firestore if our bloc is empty
  getNusachList(AppModel appModel) {
    // appModel.nusachList == null || appModel.nusachList.isEmpty ||
    if(_nusachList.length == 0)
      _getNusachFromFirebase(appModel);
    else
      //Get it from shared prefs
      appModel.setNusachList(_nusachList);
      addNusach(appModel.nusachList);
  }

  void dispose() async {
    await _nusach.drain();
    _nusach.close();
  }
}

final blocNusach = NusachBloc();
