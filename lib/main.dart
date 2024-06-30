


import 'package:crudops/screens/splashpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDGWbzDClwnPY_7ZY6tsHRZqHgNwfbXXGA",
        appId: "1:472992537165:android:6d357cd3f211041ea01a04",
        messagingSenderId: "472992537165",
        projectId: "crudops-95cb6",
        storageBucket: "crudops-95cb6.appspot.com",
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: SplashPage()
    );
  }
}
