import 'package:flutter/cupertino.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String mainCollec = 'users';
  String subCollect = 'allContacts';
  String _userId = '-1';

  Contatos();

  Contatos.loggedIn(this._userId);

  Stream<List<Contato>> fetchData() {
    return _firestore
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map(
              (doc) => Contato.froJson(doc.data(), doc.id),
            )
            .toList());
  }

  Future<Contato> findById(String id) async {
    final doc = await _firestore
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .doc(id)
        .get();

    final results = doc.data() ?? {};

    Contato result = Contato(doc.id, results['name'], results['email'],
        results['address'], results['cep'], results['phone_number']);

    return result;
  }

  Future<void> add(String name, String email, String address, String cep,
      String phoneNumber) async {
    final contatoID = DateTime.now().toIso8601String();
    await _firestore
        .collection(this.mainCollec)
        .doc(this._userId)
        .collection(subCollect)
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
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .doc(id)
        .delete();
  }

  Future<void> update(Contato c) async {
    notifyListeners();
    await _firestore
        .collection(this.mainCollec)
        .doc(this._userId)
        .collection(subCollect)
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
