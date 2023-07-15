import 'dart:io';
import 'package:busti007/screens/route_name.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:busti007/screens/routes_selection.dart';
import 'liveticket.dart';
import 'routes_selection.dart';
import 'welcome.dart';

class ConductorHomePage extends StatefulWidget {
  final String busID;

  ConductorHomePage({required this.busID});

  @override
  _ConductorHomePageState createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  String qrCodeImageUrl = '';

  @override
  void initState() {
    super.initState();
    loadQRCodeImage(); // Load the QR code image when the home page is initialized
  }

  Future<void> loadQRCodeImage() async {
    try {
      // Retrieve the QR code image URL from Firebase Storage
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('qr_codes')
          .child('${widget.busID}.png');
      final downloadURL = await storageReference.getDownloadURL();

      // Update the state with the QR code image URL
      setState(() {
        qrCodeImageUrl = downloadURL;
      });
    } catch (error) {
      print('Error loading QR code image: $error');
    }
  }

  void downloadQRCodeAsPDF() async {
    try {
      // Retrieve the QR code image bytes from the network
      final response = await http.get(Uri.parse(qrCodeImageUrl));
      final qrCodeImageBytes = response.bodyBytes;

      // Create a PDF document
      final pdf = pw.Document();

      // Add a page to the PDF document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(qrCodeImageBytes),
              fit: pw.BoxFit.contain,
            );
          },
        ),
      );

      // Get the temporary directory path
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      // Save the PDF document to a temporary file
      final output = File('$tempPath/${widget.busID}_qr_code.pdf');
      await output.writeAsBytes(await pdf.save());

      // Open the PDF file with the default PDF viewer
      OpenFile.open(output.path);
    } catch (error) {
      print('Error downloading QR code as PDF: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (qrCodeImageUrl.isNotEmpty)
                      Image.network(
                        qrCodeImageUrl,
                        width: 200, // Adjust the width to make the image larger
                        height: 80, // Adjust the height to make the image larger
                        fit: BoxFit.contain,
                      ),
                    ElevatedButton(
                      onPressed: downloadQRCodeAsPDF,
                      child: Text('Download QR as PDF'),
                    ),
                  ],
                ),
              ),
            ),

            // Drawer Items
           
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
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
                    builder: (context) => RouteManagement(busID: widget.busID,)
                  ),
                );
              },
              child: Text('Route Management'),
            ),
            
          ],
        ),
      ),
    );
  }
}
