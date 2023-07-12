import 'package:busti007/screens/qrcode.dart';
import 'package:busti007/screens/routes_selection.dart';
import 'package:flutter/material.dart';
import 'liveticket.dart';
import 'welcome.dart';

class ConductorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveTicketsPage(),
                  ),
                );
              },
              child: Text('Live Tickets'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                );
              },
              child: Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteSelectionPage(),
                  ),
                );
              },
              child: Text('Select Routes & Fares'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodePage(),
                  ),
                );
              },
              child: Text('QR Code'),
            ),

          ],
        ),
      ),
    );
  }
}
