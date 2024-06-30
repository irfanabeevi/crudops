import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? imgurl;
  DateTime? createdAt;
  int? status;

  AuthModel(
      {this.name,
      this.email,
      this.password,
      this.imgurl,
      this.id,
      this.createdAt,
      this.status});

  factory AuthModel.fromJson(DocumentSnapshot data){
    return AuthModel(
      email: data['email'],
      id:data['uid'],
      name:data['name'],
      status:data['status'],
      createdAt:data['createdAt']
    );
  }
  Map<String,dynamic>toJson(){
    return{
      'id':id,
      'name':name,
      'email':email,
      'password':password,
      'status':status,
      'createdAt':createdAt
    };
  }

}
