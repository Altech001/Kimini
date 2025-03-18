import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kimini/screen/info/home_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep indigo
              Colors.white, // Indigo
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // App logo
              // Icon(
              //   CupertinoIcons.shield_fill,
              //   size: 30,
              //   color: Color(0xFF1A237E),
              // ),
              const SizedBox(height: 20),
              // App name
              const Text(
                'Kimini',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Terms and conditions title
              const Text(
                'KYC Customer Terms & Conditions',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Terms and conditions content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 1,
                        spreadRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: const Text(
                      'By using the Kimini application, you agree to the following terms and conditions:\n\n'
                      '1. PRIVACY POLICY\n'
                      'We collect personal information to verify your identity in accordance with KYC regulations. This information may include, but is not limited to, your name, address, date of birth, identification documents, and biometric data. Please refer to our full Privacy Policy for details on how your information is processed.\n\n'
                      '2. DATA USAGE\n'
                      'Your data will be used solely for the purpose of identity verification and compliance with applicable laws and regulations. We implement industry-standard security measures to protect your information.\n\n'
                      '3. USER RESPONSIBILITIES\n'
                      'You agree to provide accurate, current, and complete information during the verification process. Submission of false or misleading information may result in rejection of your application and potential legal consequences.\n\n'
                      '4. THIRD-PARTY SERVICES\n'
                      'We may use trusted third-party verification services to validate your information. By accepting these terms, you consent to the sharing of your information with these service providers.\n\n'
                      '5. LIABILITY LIMITATIONS\n'
                      'We strive to provide reliable service but cannot guarantee uninterrupted access. We are not liable for any damages arising from your use of this application or inability to use it.\n\n'
                      '6. TERMINATION\n'
                      'We reserve the right to terminate or suspend your access to the application at any time, without prior notice, for violations of these terms or for any other reason at our discretion.\n\n'
                      '7. CHANGES TO TERMS\n'
                      'We may modify these terms at any time. Continued use of the application after changes constitutes acceptance of the updated terms.\n\n'
                      '8. GOVERNING LAW\n'
                      'These terms are governed by and construed in accordance with the laws of the jurisdiction in which the company operates.\n\n'
                      'By proceeding, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        // color: Colors.white,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Checkbox to accept terms
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    activeColor: Color(0xFF1A237E),
                    onChanged: (bool? value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptedTerms = !_acceptedTerms;
                        });
                      },
                      child: const Text(
                        'I have read and agreed to the Terms & Conditions above.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Continue button
              ElevatedButton(
                onPressed:
                    _acceptedTerms
                        ? () {
                          // Navigate to the next screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const VerificationScreen(),
                            ),
                          );
                        }
                        : null, // Button disabled if terms not accepted
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
