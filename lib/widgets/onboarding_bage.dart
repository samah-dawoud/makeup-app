import 'package:flutter/material.dart';
import 'package:makeup/widgets/bottom_wave_clipper.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: SizedBox(
        height:
            mediaQuery.size.height, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1,
                    vertical: mediaQuery.size.height * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: mediaQuery.size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: mediaQuery.size.height * 0.02,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
