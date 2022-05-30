import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Page/Login_page.dart';
import 'Page/VerifyEmailPage.dart';
import 'Page/adress.dart';
import 'Page/showLoading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Page/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const LoginDoctell());
}

class LoginDoctell extends StatelessWidget {
  const LoginDoctell({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool? isLogin;

    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isLogin = false;
    } else {
      isLogin = true;
    }
  
       Widget going()  {
      bool? exist;
       if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        return VerifyEmailPage();
      } else{
        
      FirebaseFirestore.instance
          .collection("Adresses")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((docs) {
        exist = docs.exists;
        print(exist);
      });

       if (exist == false) {
        return adress();
      }}
      return SplashScreen(title: "title");
    }

    Color _PrimaryColor = HexColor("#397EF5");
    Color _accentColor = Colors.lightBlueAccent;
    return GetMaterialApp(
      routes: {
        "home": (context) => HomePgae(),
        "login": (context) => LoginPage(),
        "verify": (context) => VerifyEmailPage(),
        "adress": (context) => adress(),
        "splash": (context) => SplashScreen(title: "title"),
      },
      debugShowCheckedModeBanner: false,
      title: 'Login Logout Page',
      theme: ThemeData(
        primaryColor: _PrimaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        primarySwatch: Colors.grey,
      ),
      home: isLogin ? going() : SplashScreen(title: 'Splash scree'),

      // const SplashScreen(title: 'Doctell Login Page'),
    );
  }
}
