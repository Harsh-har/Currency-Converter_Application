import 'package:flutter/material.dart';
import 'Home_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            Column(
              children: [
                Image.asset(
                  'assets/images/logocurrency.png',
                  height: 130,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Currency Converter',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Convert, Track & Stay Updated on Global Currencies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Real-time exchange rates at your fingertips',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
