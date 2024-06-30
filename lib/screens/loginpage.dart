import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudops/screens/registrationpage.dart';

import 'package:flutter/material.dart';

import '../models/authmodel.dart';
import '../services/authservice.dart';
import '../widgets/container.dart';
import '../widgets/text.dart';
import '../widgets/textformfield.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _visible = true;
  bool remember = false;

  var _myFormKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  Future<void> _login() async {
    DocumentSnapshot? userDoc = await _authService.loginUser(
      AuthModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    if (userDoc != null) {
      AuthModel user = AuthModel(
        id: userDoc['uid'],
        email: userDoc['email'],
        name: userDoc['name'],
        imgurl: userDoc['imgurl'],
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: user)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'CRUD',
          textclr: Colors.black,
          fontsize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Form(
          key: _myFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Center(child: Image.asset('assets/images/login_img.png')),
                SizedBox(height: 30),
                SizedBox(
                  height: 57,
                  width: 348,
                  child: CustomTextFormField(
                    controller: emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: "Username",
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 57,
                  width: 348,
                  child: CustomTextFormField(
                    controller: passwordController,
                    obscureText: _visible,
                    labelText: "password",
                    suffixIcon: IconButton(
                      onPressed: showPassword,
                      icon: _visible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                CustomContainer(
                  height: 48,
                  width: 250,
                  color:Color(0xFF3C377E) ,
                //  boxborder: Border.all(color: Color(0xFF3C377E), width: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.white),
                      SizedBox(width: 10),
                      CustomText(text: 'Login', textclr: Colors.white),
                    ],
                  ),
                  onTap: _login,
                ),

                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        );
                      },
                      child: CustomText(text: 'Create Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      _visible = !_visible;
    });
  }
}
