// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kimini/screen/info/first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const FirstScreen()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              Color(0xFF1A1A32), // Dark indigo
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo container with animated glow
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2A3C9D), // Medium indigo
                                Color(0xFF4A5CFF), // Bright indigo
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF4A5CFF).withOpacity(
                                  0.2 + (_glowAnimation.value * 0.4),
                                ),
                                blurRadius: 20 + (_glowAnimation.value * 15),
                                spreadRadius: 1 + (_glowAnimation.value * 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.shield_fill,
                              size: 70,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // App name with stylish typography
                        Text(
                          "KIMINI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tagline with elegant styling
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "PREMIUM IDENTITY VERIFICATION",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        // Custom loading indicator
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF4A5CFF).withOpacity(0.3),
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Animated loading arc
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.linear,
                                  ),
                                ),
                                child: CustomPaint(
                                  size: Size(50, 50),
                                  painter: LoadingArcPainter(),
                                ),
                              ),
                              // Center dot
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4A5CFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4A5CFF).withOpacity(0.6),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Loading text
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            "LOADING...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              letterSpacing: 3.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom painter for the loading arc animation
class LoadingArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * 3.14,
      colors: [Color(0xFF4A5CFF), Color(0x004A5CFF)],
      stops: [0.25, 0.75],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0.0, 3 * 3.14, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
