import 'package:flutter/cupertino.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      );
    }).toList();

    notifyListeners();
  }

  Contato findById(String id) =>
      _items.firstWhere((element) => element.id == id);

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

    _items.add(Contato(contatoID, name, email, address, cep, phoneNumber));
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _firestore
        .collection(mainCollec)
        .doc(_userId)
        .collection(subCollect)
        .doc(id)
        .delete();
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> update(Contato c) async {
    int index = _items.indexWhere((element) => element.id == c.id);

    if (index == -1) return;

    _items[index] = c;

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
    notifyListeners();
  }
}
