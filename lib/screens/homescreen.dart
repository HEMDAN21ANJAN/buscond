import 'package:busti007/screens/login_passenger.dart';
import 'package:busti007/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/loginPassenger': (context) => LoginScreen1(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hemdan'),

      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Login'),
          onPressed: () {
            signout(context);
            // Navigator.push(context,MaterialPageRoute(
            //           builder: (context) => LoginScreen1(),
            //         ),
            //          );
          },
        ),
      ),
    );
  }


  signout(BuildContext ctx) async
  {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => WelcomeScreen()), (route) => false);
  }
}