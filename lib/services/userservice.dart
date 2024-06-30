import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usermodel.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("addeduser");

  //create or add new user
  Future<UserModel?> createUser(UserModel user) async {
    try {
      final userMap = user.toMap();
      await _userCollection.doc(user.id).set(userMap);
      return user;
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Stream<List<UserModel>> getAllUsers() {
    try {
      return _userCollection.snapshots().map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return UserModel.fromJson(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e);
      throw (e);
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try{
      final userMap=user.toMap();
      await _userCollection.doc(user.id).update(userMap);
    }on FirebaseException catch(e){
      print(e.toString());
    }

  }


  // Delete user
  Future<void> deleteUser(String? id) async {
    try{
      await _userCollection.doc(id).delete();
    }on FirebaseException catch(e){
      print(e.toString());
    }

  }
}
