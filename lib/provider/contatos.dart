import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final imageStorage = FirebaseStorage.instance;
  String mainCollec = 'users';
  String subCollect = 'allContacts';
  String _userId = '-1';

  List<Contato> _items = [];

  List<Contato> get items => [..._items];

  int get size => _items.length;

  Contatos();

  Contatos.loggedIn(this._userId);

  Future<void> fetchData() async {
    final data = await _firestore
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .get();

    final documents = data.docs;

    if (documents.length == 0) return;

    _items = documents.map((element) {
      Map<String, dynamic> contatoData = element.data();
      return Contato(
          element.id,
          contatoData['name'],
          contatoData['email'],
          contatoData['address'],
          contatoData['cep'],
          contatoData['phone_number'],
          contatoData['image_url'],
          contatoData['birthday']);
    }).toList();

    notifyListeners();
  }

  Contato findById(String id) =>
      _items.firstWhere((element) => element.id == id);

  Future<void> add(String name, String email, String address, String cep,
      String phoneNumber, String aniversario, File image) async {
    String url = 'N/A';
    final contatoID = DateTime.now().toIso8601String();
    if (image.existsSync()) {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(_userId + contatoID + '.jpg');

      await ref.putFile(image);

      url = await ref.getDownloadURL();
    }

    final newContato = Contato(
        contatoID, name, email, address, cep, phoneNumber, url, aniversario);

    await _firestore
        .collection(this.mainCollec)
        .doc(this._userId)
        .collection(subCollect)
        .doc(contatoID)
        .set(newContato.toMap);

    _items.add(newContato);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    int index = _items.indexWhere((element) => element.id == id);

    if (index == -1) return;

    final contactToRemove = _items[index];

    if (contactToRemove.pathExists) {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(_userId + id + '.jpg');

      ref.delete();
    }

    _items.remove(contactToRemove);

    await _firestore
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .doc(id)
        .delete();

    notifyListeners();
  }

  Future<void> update(Contato c, File image) async {
    int index = _items.indexWhere((element) => element.id == c.id);

    if (index == -1) return;

    String url = 'N/A';

    if (image.existsSync()) {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(_userId + c.id + '.jpg');

      await ref.putFile(image);

      url = await ref.getDownloadURL();
    }

    c.imageFile = url;

    _items[index] = c;

    await _firestore
        .collection(this.mainCollec)
        .doc(this._userId)
        .collection(subCollect)
        .doc(c.id)
        .update(c.toMap);
    notifyListeners();
  }
}
