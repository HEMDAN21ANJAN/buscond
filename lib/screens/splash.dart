import 'dart:ffi';

import 'package:busti007/main.dart';
import 'package:busti007/screens/homescreen.dart';
import 'package:busti007/screens/login_conductor.dart';
import 'package:busti007/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {   // splash screen initial 
    checkUserLoggedin();// TODO: implement initState
    super.initState();
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/image1.png',
        height: 250,),
      ),
      );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoLogin() async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => WelcomeScreen(),
      ),
      );
  }


  Future<void> checkUserLoggedin() async{
    final _sharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY_NAME);
    if (_userLoggedIn == null || _userLoggedIn == false)
    {
      gotoLogin();
      final _sharedPrefs = await SharedPreferences.getInstance();
    }
    else
    {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx1) => HomePage()));
    }
  }
}