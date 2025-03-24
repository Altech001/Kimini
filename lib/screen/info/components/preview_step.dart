// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';

class PreviewStep extends StatefulWidget {
  final Function(File?) func;
  final Function() onPressed;
  const PreviewStep({
    super.key,
    required this.func,
    //
    required this.onPressed,
  });

  @override
  State<PreviewStep> createState() => _PreviewStepState();
}

class _PreviewStepState extends State<PreviewStep> {
  Map<String, dynamic> userData = {};
  List<String> documentPaths = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = {
          'name': prefs.getString('name') ?? '',
          'dateOfBirth': prefs.getString('dateOfBirth') ?? '',
          'idNumber': prefs.getString('idNumber') ?? '',
          'email': prefs.getString('email') ?? '',
          'phone': prefs.getString('phone') ?? '',
          'address': prefs.getString('address') ?? '',
          'city': prefs.getString('city') ?? '',
        };
        documentPaths = prefs.getStringList('documentPaths') ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveDraft() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('documentPaths', documentPaths);
      for (var entry in userData.entries) {
        await prefs.setString(entry.key, entry.value.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
          // padding: EdgeInsets.all(8.0),
          backgroundColor: Colors.blue.shade800.withOpacity(0.9),
          showCloseIcon: true,
          margin: EdgeInsets.all(10),
          content: Text(
            'Draft saved successfully!',
            style: TextStyle(fontSize: 12, letterSpacing: 1.4),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
          // padding: EdgeInsets.all(8.0),
          backgroundColor: Colors.red.shade800.withOpacity(0.9),
          showCloseIcon: true,
          margin: EdgeInsets.all(10),
          content: Text(
            'Draft saving Error: $e',
            style: TextStyle(fontSize: 12, letterSpacing: 1.4),
          ),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _viewDocument(String path) async {
    try {
      await OpenFile.open(path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> generatePDF() async {
    setState(() => isLoading = true);
    try {
      final pdf = pw.Document();

      // Add user information page
      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            return [
              pw.Header(level: 0, child: pw.Text('KYC Submission Form')),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, child: pw.Text('Personal Information')),
              ...userData.entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 120,
                        child: pw.Text(
                          entry.key,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Text(entry.value.toString()),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, child: pw.Text('Uploaded Documents')),
              ...documentPaths.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Text(
                    'Document ${entry.key + 1}: ${entry.value.split('/').last}',
                  ),
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/kyc_submission.pdf');
      await file.writeAsBytes(await pdf.save());

      // Open the generated PDF
      // await _viewDocument(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 2),
            _buildPersonalInfoSection(),
            const SizedBox(height: 16),
            _buildDocumentsSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Almost Done!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              // color: Colors.grey.shade300,
              letterSpacing: 1.5,
            ),
          ),
          // const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Please review your information before final submission',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
                fontFamily: 'Gerogia',
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    void Function()? onPressed;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.white],
        ),
        border: Border.all(color: Colors.blue.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.person_2,
                  color: Colors.blue.shade800.withOpacity(0.8),
                ),
                const SizedBox(width: 10),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gerogia',
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.pencil_ellipsis_rectangle,
                    color: Colors.blue.shade800.withOpacity(0.8),
                    size: 20,
                  ),
                  onPressed: onPressed,
                  tooltip: 'Edit Information',
                ),
              ],
            ),
            const Divider(thickness: 0.5),
            const SizedBox(height: 15),
            _buildInfoRow('Full Name', userData['name'] ?? ''),
            _buildInfoRow('Date of Birth', userData['dateOfBirth'] ?? ''),
            _buildInfoRow('ID Number', userData['idNumber'] ?? ''),
            _buildInfoRow('Email Address', userData['email'] ?? ''),
            _buildInfoRow('Phone Number', userData['phone'] ?? ''),
            _buildInfoRow('Address', userData['address'] ?? ''),
            _buildInfoRow('City', userData['city'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label :",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '(Not provided)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: value.isNotEmpty ? Colors.black87 : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Colors.blue.shade800.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.doc, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  'My Documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800.withOpacity(0.8),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.pencil_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.maybeOf(context);
                  },
                  tooltip: 'Edit Documents',
                ),
              ],
            ),
            const Divider(thickness: 0.9),
            const SizedBox(height: 5),
            documentPaths.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.doc_on_doc_fill,
                          size: 50,
                          color: Colors.blue.shade300,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No documents uploaded yet',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documentPaths.length,
                  separatorBuilder:
                      (context, index) =>
                          Divider(color: Colors.grey.shade200, thickness: 1),
                  itemBuilder: (context, index) {
                    final fileName = documentPaths[index].split('/').last;
                    IconData fileIcon;

                    if (fileName.endsWith('.pdf')) {
                      fileIcon = Icons.picture_as_pdf;
                    } else if (fileName.endsWith('.jpg') ||
                        fileName.endsWith('.jpeg') ||
                        fileName.endsWith('.png')) {
                      fileIcon = Icons.image;
                    } else {
                      fileIcon = Icons.insert_drive_file;
                    }

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(fileIcon, color: Colors.blue.shade700),
                      ),
                      title: Text(
                        'Document ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        fileName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.blue),
                        onPressed: () => _viewDocument(documentPaths[index]),
                        tooltip: 'View Document',
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final size = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: [
          if (isLoading)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 18,
              ),
            ),

          ElevatedButton(
            onPressed: isLoading ? null : generatePDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(CupertinoIcons.capsule, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Submit Application',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          TextButton(
            onPressed: isLoading ? null : _saveDraft,
            child: Text(
              'Save as Draft',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your information is securely encrypted',
            style: TextStyle(
              fontFamily: 'Gerogia',
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'SSL Protected',
                style: TextStyle(
                  fontFamily: 'Gerogia',
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
