import 'dart:convert';
import 'dart:typed_data';
import 'package:qr/qr.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'login_conductor.dart';

class SignUpConductor extends StatefulWidget {
  @override
  _SignUpConductorState createState() => _SignUpConductorState();
}

class _SignUpConductorState extends State<SignUpConductor> {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    busIDController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }



void generateAndUploadQRCode(String busID) async {
  try {
    // Generate the QR code data
    String qrCodeData = '$busID';

    // Create a QR code image
    final qrCode = QrPainter(
      data: qrCodeData,
      version: QrVersions.auto,
      gapless: true,
    );

    // Render the QR code to an image
    final ui.Image qrCodeImage = await qrCode.toImage(400);

    // Convert the image to bytes
    final ByteData? byteData = await qrCodeImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List qrCodeBytes = byteData!.buffer.asUint8List();

    // Upload the QR code image to Firestore
    final storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('qr_codes')
        .child('$busID.png');

    final uploadTask = storageReference.putData(qrCodeBytes);
    await uploadTask;

    // Get the download URL of the uploaded QR code
    final downloadURL = await storageReference.getDownloadURL();

    // Update the conductor document in Firestore with the QR code download URL
    await FirebaseFirestore.instance.collection('conductors').doc(busID).update({
      'qrCode': downloadURL,
    });

    // Registration successful
    // Navigate to the login page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration failed: ${error.toString()}'),
      ),
    );
  }
}


  void registerConductor(BuildContext context) async {
    try {
      String busID = busIDController.text;
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords don't match"),
          ),
        );
        return;
      }

      // Register the conductor in Firestore
      await FirebaseFirestore.instance.collection('conductors').doc(busID).set({
        'phoneNumber': phoneNumber,
        'busID': busID,
        'password': password,
      });

      // Generate and upload the QR code
      generateAndUploadQRCode(busID);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${error.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: busIDController,
              decoration: const InputDecoration(labelText: 'Bus ID'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                  labelText: "Conductor's Phone Number"),
              keyboardType: TextInputType.phone,
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
                registerConductor(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
