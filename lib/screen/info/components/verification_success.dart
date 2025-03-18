// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class VerificationSuccessScreen extends StatefulWidget {
  const VerificationSuccessScreen({super.key});

  @override
  State<VerificationSuccessScreen> createState() =>
      _VerificationSuccessScreenState();
}

class _VerificationSuccessScreenState extends State<VerificationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    )..play();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blue.shade50, Colors.white],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildSuccessIcon(),
                      ),
                      const SizedBox(height: 20),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 40),
                      _buildStatusCard(),
                      const SizedBox(height: 24),
                      _buildNextSteps(),
                      const SizedBox(height: 40),
                      _buildContinueButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Color(0xFF3A86FF),
                Color(0xFFFF006E),
                Color(0xFFFFBE0B),
                Color(0xFF8338EC),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Icon(
          CupertinoIcons.checkmark_shield_fill,
          size: 70,
          color: Colors.green.shade500,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Verification Complete!',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Georgia',
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'Your identity verification has been submitted successfully. We will review your documents and notify you once the verification is complete.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          height: 1.6,
          color: Colors.grey.shade700,
          fontFamily: 'Georgia',
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const CupertinoActivityIndicator(
                  radius: 12,
                  color: Color(0xFF3A86FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Review in Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Georgia',
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Estimated completion: 24-48 hours',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'Georgia',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.blue.shade50,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF3A86FF),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                'Under Review',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                'Verified',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            'What`s Next?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            icon: CupertinoIcons.bell_fill,
            title: 'You`ll receive an Email notification',
            description: 'We`ll update you when verification is complete',
          ),
          const SizedBox(height: 12),
          _buildStepItem(
            icon: CupertinoIcons.lock_shield_fill,
            title: 'You will access UnLimited Api_Keys',
            description: 'Gain full access to all platform features',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,

            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 15, color: const Color(0xFF3A86FF)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Georgia',
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A86FF), Color(0xFF4361EE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A86FF).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            // onTap: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.white.withOpacity(0.8),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
