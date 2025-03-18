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
              Color(0xFF0F0F1E), // Deep dark blue
              Color(0xFF1E1E3A), // Dark indigo
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // App logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4A5CFF), // Bright indigo
                        Color(0xFF2A3C9D), // Medium indigo
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A5CFF).withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.shield_fill,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name
              const Text(
                'KIMINI',
                style: TextStyle(
                  fontSize: 32,
                  letterSpacing: 2.0,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Tagline
              const Text(
                'Premium Identity Verification',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontFamily: 'Georgia',
                  color: Color(0xFFB0B0C0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Terms and conditions title
              const Text(
                'KYC Customer Terms & Conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD0D0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Terms and conditions content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A2E).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFF3A3A5A), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
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
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFFB0B0C0),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Checkbox to accept terms with custom design
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            _acceptedTerms
                                ? Color(0xFF4A5CFF)
                                : Color(0xFF3A3A5A),
                        width: 2,
                      ),
                      color:
                          _acceptedTerms
                              ? Color(0xFF4A5CFF)
                              : Colors.transparent,
                    ),
                    child: Checkbox(
                      value: _acceptedTerms,
                      activeColor: Colors.transparent,
                      checkColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide.none,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptedTerms = !_acceptedTerms;
                        });
                      },
                      child: const Text(
                        'I have read and agreed to the Terms & Conditions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFD0D0E0),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Continue button with enhanced design
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
                  backgroundColor: Color(0xFF4A5CFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 8,
                  shadowColor: Color(0xFF4A5CFF).withOpacity(0.5),
                  disabledBackgroundColor: Color(0xFF2A2A3A),
                  disabledForegroundColor: Color(0xFF6A6A7A),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.0,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
