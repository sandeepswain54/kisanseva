import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserServices{
  String collection = 'users';
  FirebaseFirestore _firestore =FirebaseFirestore.instance;


  Future<void> createUserData(Map<String,dynamic> value) async{
    String id = value['id'];
    await _firestore.collection(collection).doc(id).set(value);
  }

  Future<void> updateUserData(Map<String,dynamic>value) async{
    String id = value['id'];
    await _firestore.collection(collection).doc(id).update(value);
  }

  Future<void>getUserById( String id)async{
    await _firestore.collection(collection).doc(id).get().then((doc){
      if(doc.data()==null){
        return null;
      }
      return UserModel.fromSnapshot(doc);
    });
  }

}