import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class PreviewStep extends StatefulWidget {
  const PreviewStep({Key? key}) : super(key: key);

  @override
  State<PreviewStep> createState() => _PreviewStepState();
}

class _PreviewStepState extends State<PreviewStep> {
  Map<String, dynamic> userData = {};
  List<String> documentPaths = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {
        'name': prefs.getString('name') ?? '',
        'address': prefs.getString('address') ?? '',
        'city': prefs.getString('city') ?? '',
        // Add other fields as needed
      };
      documentPaths = prefs.getStringList('documentPaths') ?? [];
      isLoading = false;
    });
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('KYC Submission Form')),
              pw.SizedBox(height: 20),
              pw.Text('Personal Information'),
              pw.Text('Name: ${userData['name']}'),
              pw.Text('Address: ${userData['address']}'),
              pw.Text('City: ${userData['city']}'),
              // Add more fields as needed
            ],
          );
        },
      ),
    );

    // Save PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/kyc_submission.pdf');
    await file.writeAsBytes(await pdf.save());

    // You can implement sharing or downloading the PDF here
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview Submission',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPersonalInfoSection(),
              const SizedBox(height: 20),
              _buildDocumentsSection(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generatePDF,
                child: const Text('Generate PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Name: ${userData['name']}'),
            Text('Address: ${userData['address']}'),
            Text('City: ${userData['city']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploaded Documents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documentPaths.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.file_present),
                  title: Text('Document ${index + 1}'),
                  subtitle: Text(documentPaths[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
