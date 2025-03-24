// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final String stepDescription;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
    required this.stepDescription,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentStep + 1) / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F1E), // Deep dark blue
            Color(0xFF1E1E3A), // Dark indigo
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF232342).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF3A3A5A), width: 1),
                ),
                child: Text(
                  'Step ${currentStep + 1} of $totalSteps',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'KYC Verification',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getProgressColor(progress).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getProgressColor(progress).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: _getProgressColor(progress),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              // Background blur effect
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: Color(0xFF232342),
                ),
              ),
              // Progress indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * progress - 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: _getProgressGradient(progress),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getProgressColor(progress).withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ),
              ),
              // Step indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  totalSteps,
                  (index) => Container(
                    height: 12,
                    width: 3,
                    color:
                        index < currentStep
                            ? Colors.transparent
                            : index == currentStep
                            ? Colors.white.withOpacity(0.8)
                            : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            stepTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stepDescription,
            style: const TextStyle(
              color: Color(0xFFB0B0C0),
              fontSize: 12,
              height: 1.5,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.25) {
      return Color(0xFF4A5CFF); // Bright indigo
    } else if (progress <= 0.5) {
      return Color(0xFF5D6DFF); // Lighter indigo
    } else if (progress <= 0.75) {
      return Color(0xFF7A8CFF); // Light indigo/purple
    } else {
      return Color(0xFF9AACFF); // Very light indigo/lavender
    }
  }

  List<Color> _getProgressGradient(double progress) {
    if (progress <= 0.25) {
      return [Color(0xFF4A5CFF), Color(0xFF6A7CFF)];
    } else if (progress <= 0.5) {
      return [Color(0xFF5D6DFF), Color(0xFF7A8CFF)];
    } else if (progress <= 0.75) {
      return [Color(0xFF7A8CFF), Color(0xFF9AACFF)];
    } else {
      return [Color(0xFF9AACFF), Color(0xFFB5C2FF)];
    }
  }
}
