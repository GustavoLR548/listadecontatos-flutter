import 'package:flutter/cupertino.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collectionName = 'contacts';

  List<Contato> _items = [];
  String _userId = '-1';

  List<Contato> get items => [..._items];

  int get size => _items.length;

  Contatos();

  Contatos.loggedIn(this._userId);

  Contato find(String id) {
    return _items.firstWhere((element) => element.telefone == id);
  }

  Future<void> fetchData() async {
    final firebaseData = await _firestore
        .collection(this.collectionName)
        .doc(this._userId)
        .get();

    if (!firebaseData.exists) return;

    final contatosUser =
        firebaseData.data() as Map<String, Map<String, dynamic>>;

    if (contatosUser.length == 0) return;

    contatosUser.forEach((key, value) {
      Contato newContato = Contato(
          value['creator_id'],
          value['name'],
          value['email'],
          value['address'],
          value['cep'],
          value['phone_number']);
      _items.add(newContato);
    });

    notifyListeners();
  }

  Future<void> add(String name, String email, String address, String cep,
      String phoneNumber) async {
    Contato newContato =
        Contato(this._userId, name, email, address, cep, phoneNumber);
    _items.add(newContato);
    _items.sort((a, b) => a.nome.compareTo(b.nome));
    await _firestore.collection(this.collectionName).doc(this._userId).set({
      phoneNumber: {
        'name': name,
        'email': email,
        'address': address,
        'cep': cep
      },
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((element) => element.telefone == id);
    final firebaseData = await _firestore
        .collection(this.collectionName)
        .doc(this._userId)
        .get();

    if (!firebaseData.exists) return;

    final contatosUser =
        firebaseData.data() as Map<String, Map<String, dynamic>>;

    if (contatosUser.length == 0) return;

    contatosUser.removeWhere((key, value) => key.compareTo(id) == 0);
    await _firestore
        .collection(this.collectionName)
        .doc(this._userId)
        .set(contatosUser);
    notifyListeners();
  }

  Future<void> update(Contato c) async {
    final contaIndex = _items.indexOf(c);

    if (contaIndex < 0) return;

    _items[contaIndex] = c;
    notifyListeners();
    await _firestore.collection(this.collectionName).doc(this._userId).update({
      c.telefone: {
        'name': c.nome,
        'email': c.email,
        'address': c.endereco,
        'cep': c.cep
      },
    });
    notifyListeners();
  }
}
