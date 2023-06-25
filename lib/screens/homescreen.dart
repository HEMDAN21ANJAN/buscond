import 'package:busti007/screens/login_passenger.dart';
import 'package:flutter/material.dart';

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
            Navigator.push(context,MaterialPageRoute(
                      builder: (context) => LoginScreen1(),
                    ),
                     );
          },
        ),
      ),
    );
  }
}