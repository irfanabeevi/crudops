import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? imgurl;
  DateTime? createdAt;
  int? status;

  UserModel(
      {this.name,
        this.email,
        this.phone,
        this.imgurl,
        this.id,
        this.createdAt,
        this.status});

  factory UserModel.fromJson(DocumentSnapshot json){
    Timestamp? timestamp=json['createdAt'];
    return UserModel(
        email: json['email'],
        id:json['id'],
        name:json['name'],
        status:json['status'],
        phone:json['phone'],
        createdAt:timestamp?.toDate()
    );
  }
  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'name':name,
      'email':email,
      'phone':phone,
      'status':status,
      'createdAt':createdAt
    };
  }

}
