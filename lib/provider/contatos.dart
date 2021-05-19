import 'package:flutter/cupertino.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collectionName = 'contacts';
  String _userId = '-1';

  Contatos();

  Contatos.loggedIn(this._userId);

  Stream<List<Contato>> fetchData() {
    return _firestore
        .collection(collectionName)
        .doc(_userId)
        .collection('allContacts')
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map(
              (doc) => Contato.froJson(doc.data(), doc.id),
            )
            .toList());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> findById(String id) async {
    return await _firestore
        .collection(collectionName)
        .doc(_userId)
        .collection('allContacts')
        .doc(id)
        .get();
  }

  Future<void> add(String name, String email, String address, String cep,
      String phoneNumber) async {
    final contatoID = DateTime.now().toIso8601String();
    await _firestore
        .collection(this.collectionName)
        .doc(this._userId)
        .collection('allContacts')
        .doc(contatoID)
        .set({
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'address': address,
      'cep': cep
    });
    notifyListeners();
  }

  Future<void> remove(String id) async {
    return _firestore
        .collection(collectionName)
        .doc(_userId)
        .collection('allContacts')
        .doc(id)
        .delete();
  }

  Future<void> update(Contato c) async {
    notifyListeners();
    await _firestore
        .collection(this.collectionName)
        .doc(this._userId)
        .collection('allContacts')
        .doc(c.id)
        .update({
      'phone_number': c.telefone,
      'name': c.nome,
      'email': c.email,
      'address': c.endereco,
      'cep': c.cep
    });
  }
}
