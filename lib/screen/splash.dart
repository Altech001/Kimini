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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.9, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      // Replace 'HomeScreen()' with your actual next screen
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
              Color(0xFF1A237E), // Deep indigo
              Colors.black, // Indigo
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              spreadRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.shield,
                            size: 70,
                            color: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      // App name
                      Text(
                        "Kimini",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tagline
                      Text(
                        "Kyc Customer Identity Verification",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey.shade100,
                          fontFamily: 'Georgia',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 70),
                      // Loading indicator
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 20,
                          ),
                        ),
                      ),
                    ],
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
