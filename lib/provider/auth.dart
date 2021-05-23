import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final collectioName = 'users';

  String _username = 'null';
  String _email = 'n/a';
  String _id = '-1';
  String _imagePath = 'no path';

  bool _logado = false;

  String get id => _id;

  bool get isLogado => _logado;

  void _setUser(String username, String email, String id, String imagePath) {
    this._username = username;
    this._email = email;
    this._id = id;
    this._imagePath = imagePath;
    this._logado = true;
    notifyListeners();
  }

  Map<String, dynamic> get currUser => {
        'id': _id,
        'username': _username,
        'email': _email,
        'image_url': _imagePath,
      };

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = _auth.currentUser;
      if (user == null) return;

      String userId = authResult.user?.uid ?? '-1';
      if (userId == '-1') return;

      final userData = await _fetchUserData(userId);
      var newUser = userData.data() as Map<String, dynamic>;

      _setUser(
          newUser['username'], newUser['email'], userId, newUser['image_url']);
    } on PlatformException catch (error) {
      var message = 'Um erro ocorreu, por favor olhe usas credenciais';
      if (error.message != null) {
        message = error.message ?? '';
      }
      throw message;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(
      String username, String email, String password, File imageFile) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String userId = authResult.user?.uid ?? '-1';
      if (userId == '-1') return;

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(userId + '.jpg');

      await ref.putFile(imageFile);

      final url = await ref.getDownloadURL();

      await _firestore.collection(collectioName).doc(userId).set({
        'username': username,
        'email': email,
        'image_url': url,
      });
      _setUser(
        username,
        email,
        userId,
        url,
      );
    } on PlatformException catch (error) {
      print('error log:' + error.toString());
      var message = 'Um erro ocorreu, por favor olhe usas credenciais';
      if (error.message != null) {
        message = error.message ?? '';
      }
      throw message;
    } catch (error) {
      print('error log:' + error.toString());
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    if (!this._logado) {
      final userData = await _fetchUserData(user.uid);
      if (userData.data() == null) return false;

      var newUser = userData.data() as Map<String, dynamic>;
      _setUser(newUser['username'], newUser['email'], user.uid,
          newUser['image_url']);
    }

    return true;
  }

  Future<DocumentSnapshot> _fetchUserData(String userId) async =>
      await _firestore.collection(collectioName).doc(userId).get();

  void logout() {
    _setUser('', '', '', '');

    _auth.signOut();

    this._logado = false;
    notifyListeners();
  }
}
