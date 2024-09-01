import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String NUMBER = 'number';
  static const String ID = 'id';

  late final String _number;
  late final String _id;

  String get number => _number;
  String get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;  // Explicitly casting to Map<String, dynamic>

    _number = data[NUMBER]!;  // Using `!` to assert that these are not null
    _id = data[ID]!;
  }
}
