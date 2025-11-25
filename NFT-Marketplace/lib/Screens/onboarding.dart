import 'package:flutter/material.dart';
import '../core/resources/assets_values_manager.dart';
import '../core/resources/utils.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AssetsValuesManager.backgroundImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          TextField(
            decoration: InputDecoration(fillColor: Colors.orange, filled: true),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Center(
                child: Text(
                  Utils.welcomeTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SF Pro Display',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 300),
              Center(
                child: Container(
                  width: 306.31,
                  height: 191.02,
                  padding: EdgeInsets.all(27.03),
                  decoration: BoxDecoration(
                    color: Color(0xFF777DB3).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Explore and Mint NFTs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'You can buy and sell the NFTs of the best artists in the world.',
                        style: TextStyle(
                          color: Color(0xFFEBEBF5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
