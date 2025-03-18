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
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      progress == 1.0
                          ? Colors.white
                          : progress == 0.5
                          ? Colors.blue.shade100
                          : progress == 0.75
                          ? Colors.green.shade100
                          : Colors.blue.shade200,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0
                    ? Colors.red.shade900
                    : progress == 0.5
                    ? Colors.red.shade300
                    : progress == 0.75
                    ? Colors.red.shade400
                    : Colors.red.shade100,
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            stepTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stepDescription,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}
