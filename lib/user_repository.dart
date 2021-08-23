import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Obtengo la informacion del usuario logueado y cambio la contraseña
  changePass(String newPass) {
    var user = _firebaseAuth.currentUser();
    user.then((value) {
      value.updatePassword(newPass);
    });
  }

  Future<void> signUp(
      {String email, String password, String title, String contact}) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((firebaseUser) async {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'addUser',
      );
//    dynamic resp = await callable.call();
      await callable.call(<String, dynamic>{
        'title': title,
        'contact': contact,
        'uid': firebaseUser.user.uid,
      });

      _firebaseAuth
          .signOut(); //Deslogue al usuario creado porque firebase lo loguea automaticamente
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
    //.catchError((error) => throw Exception('No internet')
    //.then((onValue){}, onError: throw Exception('No internet')
    //);
  }

//  Future<void> sendPasswordResetEmailUserLoggedIn() async{
//    String email = await getUser();
//    return _firebaseAuth.sendPasswordResetEmail(email: email);
//    //.catchError((error) => throw Exception('No internet')
//    //.then((onValue){}, onError: throw Exception('No internet')
//    //);
//  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  Future<String> getUserUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
