// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kimini/screen/info/components/preview_step.dart';
import 'package:kimini/screen/info/customer/details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'components/document_upload_step.dart';
import 'components/progress_header.dart';
import 'components/country_document_step.dart';
import 'components/selfie_step.dart';
import 'components/address_step.dart';
// import 'components/verification_success.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// import 'components/verification_success.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String selectedCountry = 'Uganda';
  String selectedDocumentType = 'Passport';
  bool isLoading = false;
  File? _frontDocument;
  File? _backDocument;

  // Country options
  final List<String> countries = [
    'Uganda',
    'Kenya',
    'Tanzania',
    'Rwanda',
    'Burundi',
  ];

  // Document type options
  final Map<String, List<String>> documentTypes = {
    'Uganda': ['National ID', 'Passport', "Driver's License", 'Voter`s Card'],
    'Kenya': ['National ID', 'Passport', "Driver's License", 'Alien ID Card'],
    'Tanzania': ['National ID', 'Passport', "Driver's License", 'Voter`s Card'],
    'Rwanda': ['National ID', 'Passport', "Driver's License", 'Refugee ID'],
    'Burundi': ['National ID', 'Passport', "Driver's License", 'Voter`s Card'],
  };

  // Steps in verification
  final List<Map<String, dynamic>> verificationSteps = [
    {
      'title': 'Country & Document',
      'description': 'Select your country and ID document type',
      'isCompleted': false,
    },
    {
      'title': 'Personal Inform',
      'description': 'Fill in your personal information',
      'isCompleted': false,
    },
    {
      'title': 'Document Upload',
      'description': 'Upload clear photos of your document',
      'isCompleted': false,
    },
    {
      'title': 'Selfie Verification',
      'description': 'Take a selfie for facial recognition',
      'isCompleted': false,
    },
    {
      'title': 'Address Verification',
      'description': 'Provide proof of your current address',
      'isCompleted': false,
    },
  ];

  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  // Load saved preferences
  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCountry = prefs.getString('selected_country') ?? 'Uganda';
      selectedDocumentType =
          prefs.getString('selected_document_type') ??
          documentTypes[selectedCountry]![0];
      currentStep = prefs.getInt('verification_step') ?? 0;

      // Load completion status
      String? stepsData = prefs.getString('verification_steps');
      if (stepsData != null) {
        List<dynamic> savedSteps = jsonDecode(stepsData);
        for (
          int i = 0;
          i < savedSteps.length && i < verificationSteps.length;
          i++
        ) {
          verificationSteps[i]['isCompleted'] = savedSteps[i]['isCompleted'];
        }
      }
    });
  }

  // Save preferences
  Future<void> _saveUserPreferences() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', selectedCountry);
    await prefs.setString('selected_document_type', selectedDocumentType);
    await prefs.setInt('verification_step', currentStep);

    // Save steps completion status
    await prefs.setString('verification_steps', jsonEncode(verificationSteps));

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
      verificationSteps[0]['isCompleted'] = true;
      currentStep = 1;
    });

    // Save updated steps
    await prefs.setString('verification_steps', jsonEncode(verificationSteps));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Kimini Verification',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: 'Georgia',
          ),
        ),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressHeader(
                currentStep: currentStep,
                totalSteps: verificationSteps.length,
                stepTitle: verificationSteps[currentStep]['title'],
                stepDescription: verificationSteps[currentStep]['description'],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: buildCurrentStepContent(),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget buildCurrentStepContent() {
    switch (currentStep) {
      // case 0:
      //   return _buildLoadingOverlay();
      case 0:
        return CountryDocumentStep(
          selectedCountry: selectedCountry,
          selectedDocumentType: selectedDocumentType,
          countries: countries,
          documentTypes: documentTypes,
          onCountryChanged: (value) {
            setState(() {
              selectedCountry = value;
              selectedDocumentType = documentTypes[value]![0];
            });
          },
          onDocumentTypeChanged: (value) {
            setState(() {
              selectedDocumentType = value;
            });
          },
        );
      case 1:
        return CustomerDetailsScreen();
      case 2:
        return DocumentUploadStep(
          documentType: selectedDocumentType,
          onCaptureFront: (file) => _captureDocument(isFront: true),
          onCaptureBack: (file) => _captureDocument(isFront: false),
        );
      case 3:
        return SelfieStep(
          onCaptureSelfie: (File? file) {
            setState(() {
              if (file != null) {
                verificationSteps[currentStep]['isCompleted'] = true;
              }
            });
          },
        );
      case 4:
        return AddressStep(onUploadDocument: _pickAddressDocument);
      default:
        return const SizedBox();
    }
  }

  Future<void> _captureDocument({required bool isFront}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        print('Document ${isFront ? "front" : "back"} selected: ${file.path}');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isFront ? "Front" : "Back"} side document uploaded successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Here you would typically:
        // 1. Upload the file to your server
        // 2. Store the file reference

        // Mark the step as completed if both sides are uploaded
        setState(() {
          if (isFront) {
            _frontDocument = file;
          } else {
            _backDocument = file;
          }

          if (_frontDocument != null && _backDocument != null) {
            verificationSteps[currentStep]['isCompleted'] = true;
          }
        });
      }
    } catch (e) {
      print('Error picking document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting document: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> _captureSelfie() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['jpg', 'jpeg', 'png'],
  //       allowMultiple: false,
  //     );

  //     if (result != null) {
  //       String filePath = result.files.single.path!;
  //       print('Selfie selected: $filePath');

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Selfie uploaded successfully'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error picking selfie: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error selecting selfie: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> _pickAddressDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        print('Address document selected: $filePath');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address document uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error picking address document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting document: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  color: Colors.blue.shade100,
                  radius: 20,
                ),
                // const SizedBox(height: 16),
                // Text(
                //   'Processing ...',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.black,
                //     fontFamily: 'Georgia',
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: isLoading ? null : _handleContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: Colors.grey.shade400,
          ),
          child: Text(
            currentStep == 0
                ? 'Proceed'
                : (currentStep < verificationSteps.length - 1
                    ? 'Next Step'
                    : 'Complete Verification'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Handle continue button press
  void _handleContinue() {
    if (currentStep == 0) {
      _saveUserPreferences();
    } else {
      // For demo purposes, just mark the step as completed and move to next
      setState(() {
        verificationSteps[currentStep]['isCompleted'] = true;
        if (currentStep < verificationSteps.length - 1) {
          currentStep++;
        } else {
          // Complete verification process
          _completeVerification();
        }
      });
    }
  }

  // Complete verification
  Future<void> _completeVerification() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('verification_completed', true);

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const PreviewStep()));
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const VerificationSuccessScreen()),
    // );
  }
}
