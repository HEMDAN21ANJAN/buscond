//import 'dart:html';

import 'package:busti007/screens/signup_passenger.dart';
import 'package:busti007/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen1 extends StatelessWidget {
   LoginScreen1({Key? key}) : super(key: key);

final _emailController = TextEditingController();
final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 150,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),//text field for username
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),//text field for password
            const SizedBox(height: 20),
            const Text(
                'Existing User? Login',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPassenger(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'New User? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ElevatedButton.icon(onPressed: () {
              FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value) {
                Navigator.push(context,
               MaterialPageRoute(builder: (context) => WelcomeScreen()));
              }).onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });
              
            }, 
            icon: const Icon(Icons.check), 
            label: const Text('Login'))
              
          ]),
        ),
      ),
    );
  }

}