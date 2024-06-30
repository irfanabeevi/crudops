

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authmodel.dart';

final FirebaseStorage _storage=FirebaseStorage.instance;

class AuthService
{
  //firebase reference
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final CollectionReference _userCollection=FirebaseFirestore.instance.collection("user");


  Future<String>uploadImage(String childName,Uint8List file)async {
    Reference ref=_storage.ref().child(childName);
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot snapshot=await uploadTask;
    String downloadUrl=await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //register
  Future<UserCredential> registerUser(AuthModel user, Uint8List file) async {
    try {
      // Upload image and get download URL
      String fileName = DateTime.now().toString();
      String imgUrl = await uploadImage("profile/$fileName", file);

      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email.toString(),
        password: user.password.toString(),
      );

      // Save user details to Firestore
      await _userCollection.doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": userCredential.user!.email,
        "name": user.name,
        "imgurl": imgUrl,
        'createdAt': user.createdAt,
        'status': user.status,
      });

      return userCredential;
    } catch (e) {
      print("Error registering user: $e");
      throw e; // Rethrow the error for handling in UI or logging
    }
  }


  //login
  Future<DocumentSnapshot?> loginUser( AuthModel user)async{



    try{
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(
          email: user.email.toString(),
          password: user.password.toString());
      String? token=await userCredential.user!.getIdToken();
      if(userCredential!=null){
      DocumentSnapshot snap=await _userCollection.doc(userCredential!.user!.uid).get();

      print("this is $token");
      SharedPreferences prefs= await SharedPreferences.getInstance();
      await prefs.setString("token", token!);
      await  prefs.setString('name', snap['name']);
      await  prefs.setString('email', snap['email']);

      String?  _token=await prefs.getString("token");
      print("*******************************");
      print(_token);
      print("*****************************");
      return snap;
    }}
    on FirebaseAuthException catch(e) {
      print(e);
    }
    return null;
  }

  Future<void> logOut() async{

    SharedPreferences pref=await SharedPreferences.getInstance();
    await pref.clear();
    await _auth.signOut();
    String?  _token=await pref.getString("token");
    print("*******************************");
    print(_token);
    print("*****************************");

  }
  Future<bool>isLoggedin()  async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String?  _token=await pref.getString("token");
    if(_token==null){
      return false;
    }
    else
      return true;


  }



}







