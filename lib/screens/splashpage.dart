
import 'package:crudops/screens/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/container.dart';
import '../widgets/text.dart';
import 'homepage.dart';
import 'loginpage.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? name;
  String? email;
  String? uid;
  String? token;

  getData()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    token=await _pref.getString('token');
    email=await _pref.getString('name');
    uid=await _pref.getString('uid');
    name=await _pref.getString('name');

    @override
    void initState(){
      getData();
      super.initState();
    }
    Future<void>isLoggedin()async{
      if(token==null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        }
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
                'assets/images/splash_img.png'),
          ),
          SizedBox(height: 20),
          CustomText(text: 'CRUD',fontsize: 20,fontWeight: FontWeight.bold,textclr: Color(0xFF3C377E)),
          CustomText(text: 'Create, Read, Update, Delete',fontsize: 12,textclr: Color(0xFF3C377E)),
          SizedBox(height: 20),
          CustomContainer(
            height: 48,
            width: 250,
            color: Color(0xFF3C377E),
            borderRadius: 35,
            child: Center(child: CustomText(text: 'Login',textclr: Colors.white,)),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            },
          ),
          SizedBox(height: 20),
          CustomContainer(
            height: 48,
            width: 250,
            boxborder: Border.all(color: Color(0xFF3C377E),width: 2),
            child: Center(child: CustomText(text: 'Sign up',textclr: Color(0xFF3C377E))),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
              },

          )
        ],
      ),
    );
  }
}

