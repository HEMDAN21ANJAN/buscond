import 'package:busti007/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  Future<String?> getDocumentIdFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('documentId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hemdan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: getDocumentIdFromSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(
                    'Document ID: ${snapshot.data}',
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Text(
                    'Document ID not found',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            ElevatedButton(
              child: Text('Go to Login'),
              onPressed: () {
                signout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  signout(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => WelcomeScreen()),
      (route) => false,
    );
  }
}
