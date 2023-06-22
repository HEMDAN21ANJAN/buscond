import 'package:busti007/screens/login_passenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPassenger extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                Map<String,dynamic> dataToSave={
                  'Name': nameController.text,
                  'Phone Number': phoneNumberController.text,
                  'Email': emailController.text,
                  'Password': passwordController.text
                  //'Confirm Password': passwordController.text,

                };

                FirebaseFirestore.instance.collection('User').add(dataToSave);

                // Perform registration logic here
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text, ).then((value) {
                  print("Create new account");
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen1()),
                );
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });

                // After registration, navigate to the login page
                //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => LoginScreen1()),
                //);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}