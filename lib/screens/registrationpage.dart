import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/authmodel.dart';
import '../services/authservice.dart';
import '../widgets/container.dart';
import '../widgets/text.dart';
import '../widgets/textformfield.dart';
import 'homepage.dart';
import 'loginpage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {


  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final AuthService _authservice = AuthService();
  var _myFormKey = GlobalKey<FormState>();
  bool _visible = true, _isLoading = false;

  void _register() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Upload image
    String fileName = DateTime.now().toString();
    try {
      imgurl = await _authservice.uploadImage(
          "profile/$fileName", await _image!.readAsBytes());


      AuthModel user = AuthModel(
        imgurl: imgurl,
        email: emailcontroller.text.trim(),
        name: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim(),
        status: 1,
        createdAt: DateTime.now(),
      );


      final userData =
          await _authservice.registerUser(user, await _image!.readAsBytes());

      if (userData != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print("Error registering user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //for image picking
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  var imgurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'User Registration',
          ),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Form(
                    key: _myFormKey,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage:
                                          FileImage(File(_image!.path)))
                                  : CircleAvatar(
                                      radius: 64,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_img.png')),
                              Positioned(
                                  bottom: -10,
                                  left: 80,
                                  child: IconButton(
                                      onPressed: showimage,
                                      icon: Icon(Icons.add_a_photo_rounded)))
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 57,
                            width: 348,
                            child: CustomTextFormField(
                                controller: usernamecontroller,
                                hintText: "Full name",
                                suffixIcon: Icon(Icons.person_outline,
                                    color: Colors.grey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Name';
                                  }
                                }),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 57,
                            width: 348,
                            child: CustomTextFormField(
                                controller: emailcontroller,
                                hintText: "Valid email",
                                suffixIcon: Icon(Icons.mail_outline_outlined,
                                    color: Colors.grey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                }),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 57,
                            width: 348,
                            child: CustomTextFormField(
                                controller: passwordcontroller,
                                obscureText: _visible,
                                hintText: "Password",
                                suffixIcon: Icon(Icons.lock_outline_rounded,
                                    color: Colors.grey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                }),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 57,
                            width: 348,
                            child: CustomTextFormField(
                                controller: confirmpasswordcontroller,
                                obscureText: _visible,
                                hintText: "Confirm Password",
                                suffixIcon: Icon(Icons.lock_outline_rounded,
                                    color: Colors.grey),
                                validator: (value) {
                                  if (value != passwordcontroller.value.text) {
                                    return "Please enter same Password";
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(height: 15),
                          CustomContainer(
                              height: 48,
                              width: 250,
                              boxborder: Border.all(
                                  color: Color(0xFF3C377E), width: 2),
                              onTap: () async {
                                if (_myFormKey.currentState!.validate()) {
                                  //store image in firebase
                                  String fileName = DateTime.now().toString();
                                  var ref = FirebaseStorage.instance
                                      .ref()
                                      .child("profile/$fileName");
                                  UploadTask uploadTask =
                                      ref.putFile(File(_image!.path));

                                  uploadTask.then((res) async {
                                    imgurl =
                                        (await ref.getDownloadURL()).toString();
                                    print(imgurl);
                                  });

                                  _register();
                                }

                                },
                              child: Center(
                                child: CustomText(
                                    text: 'Sign Up',
                                    fontWeight: FontWeight.bold,
                                    textclr: Color(0xFF3C377E)),
                              )),
                          SizedBox(height: 70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Already have an account?",
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: CustomText(text: 'Login'))
                            ],
                          ),
                        ]))),
                Visibility(
                    visible: _isLoading,
                    child: Center(child: CircularProgressIndicator()))
              ],
            )));
  }

  _imageFromgallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('${image?.path}');

    setState(() {
      _image = image;
    });
  }

  _imageFromcamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    print('${photo?.path}');
    setState(() {
      _image = photo;
    });
  }

  showimage() {
    showModalBottomSheet(
        backgroundColor: Colors.white70,
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Ink(
                        decoration: ShapeDecoration(
                            color: Colors.deepPurple, shape: CircleBorder()),
                        child: IconButton(
                          onPressed: () {
                            _imageFromcamera();
                          },
                          splashRadius: 40,
                          icon: Icon(Icons.camera_alt_outlined,
                              color: Colors.white),
                        ),
                      ),
                      Text("camera")
                    ],
                  ),
                  SizedBox(width: 80),
                  Column(
                    children: [
                      Ink(
                        decoration: ShapeDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: CircleBorder()),
                        child: IconButton(
                          onPressed: () {
                            _imageFromgallery();
                          },
                          splashRadius: 40,
                          icon: Icon(Icons.photo, color: Colors.white),
                        ),
                      ),
                      Text("gallery")
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
