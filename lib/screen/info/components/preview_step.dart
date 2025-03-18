import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewStep extends StatefulWidget {
  const PreviewStep({Key? key}) : super(key: key);

  @override
  State<PreviewStep> createState() => _PreviewStepState();
}

class _PreviewStepState extends State<PreviewStep> {
  Map<String, dynamic> userData = {};
  List<String> documentPaths = [];

  @override
  void initState() {
    super.initState();
    userData = {
      'name': '',
      'dateOfBirth': '',
      'idNumber': '',
      'email': '',
      'phone': '',
      'address': '',
      'city': '',
    };
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF generated successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Application Preview',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              // Add help or info functionality
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildPersonalInfoSection(),
                const SizedBox(height: 16),
                _buildDocumentsSection(),
                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Almost Done!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your information before final submission',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.9,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Step 3 of 3',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue.shade700, size: 20),
                  onPressed: () {
                    // Navigate back to edit personal info
                  },
                  tooltip: 'Edit Information',
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 15),
            _buildInfoRow('Full Name', userData['name']),
            _buildInfoRow('Date of Birth', userData['dateOfBirth']),
            _buildInfoRow('ID Number', userData['idNumber']),
            _buildInfoRow('Email Address', userData['email']),
            _buildInfoRow('Phone Number', userData['phone']),
            _buildInfoRow('Address', userData['address']),
            _buildInfoRow('City', userData['city']),
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
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '(Not provided)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: value.isNotEmpty ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.file_copy, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  'Uploaded Documents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue.shade700, size: 20),
                  onPressed: () {
                    // Navigate back to edit document uploads
                  },
                  tooltip: 'Edit Documents',
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 10),
            documentPaths.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_present_rounded,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No documents uploaded yet',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
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
                        onPressed: () {
                          // View document functionality
                        },
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
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: generatePDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle),
                SizedBox(width: 12),
                Text(
                  'Submit Application',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Save as draft functionality
            },
            child: Text(
              'Save as Draft',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your information is securely encrypted',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'SSL Protected',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
