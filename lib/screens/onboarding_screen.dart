import 'package:flutter/material.dart';
import 'package:makeup/widgets/onboarding_bage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingPage(
            imagePath: 'lib/assets/images/eyeshadow.jpg',
            title: 'Affordable Eyeshadow Palettes',
            description: 'Just one click from getting all kinds of eyeshadow palettes from your favorite brands.',
            buttonText: 'Next',
            onPressed: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
          OnboardingPage(
            imagePath: 'lib/assets/images/makeup-brush.jpg',
            title: 'Popular Makeup Products Brands',
            description: 'Shop popular makeup products from Beauty Essentials.',
            buttonText: 'Next',
            onPressed: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
          OnboardingPage(
            imagePath: 'lib/assets/images/makeup_products.jpg',
            title: 'Original Designer MakeUp Products',
            description: 'Original makeup products will always make your work stand out more. Start shopping now!',
            buttonText: 'Start',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/sign_in');
            },
          ),
        ],
      ),
    );
  }
}
