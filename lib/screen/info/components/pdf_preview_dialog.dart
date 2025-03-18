import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFPreviewDialog extends StatelessWidget {
  final Map<String, String> userData;
  final String selectedGender;
  final String selectedAddres;
  final String selectedCountry;

  const PDFPreviewDialog({
    Key? key,
    required this.userData,
    required this.selectedGender,
    required this.selectedAddres,
    required this.selectedCountry,
  }) : super(key: key);

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Personal Information',
                  style: pw.TextStyle(fontSize: 24),
                ),
              ),
              pw.SizedBox(height: 20),
              _buildPdfSection('Personal Details', [
                'Name: ${userData['surname']} ${userData['givenName']}',
                'Gender: $selectedGender',
                'Date of Birth: ${userData['dob']}',
                'Phone: ${userData['phone']}',
                'Email: ${userData['email']}',
              ]),
              pw.SizedBox(height: 20),
              _buildPdfSection('KYC Information', [
                'ID Number: $selectedAddres',
                'Address: $selectedAddres',
                'Nationality: $selectedCountry',
              ]),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...items.map(
          (item) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: pw.Text(item),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Personal CV',
                style: TextStyle(fontFamily: 'Gerogia', fontSize: 14),
              ),
              centerTitle: true,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.blue.shade100),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: PdfPreview(
                build: (format) => _generatePdf(),
                allowPrinting: true,
                allowSharing: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
