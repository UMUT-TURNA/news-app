import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news/localizations/localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  textStyle: TextStyle(fontSize: 16),
                  primary: Colors.blue, // Butonun arka plan rengi
                  onPrimary: Colors.white, // Butonun yazı rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).getTranslate('login'),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/register');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  textStyle: TextStyle(fontSize: 16),
                  primary: Colors.green, // Butonun arka plan rengi
                  onPrimary: Colors.white, // Butonun yazı rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).getTranslate('register'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
