import 'package:flutter/material.dart';
import 'package:ecommerce/screens/intro/getstartpage.dart';
import 'package:ecommerce/screens/home/homepage.dart';

List<Product> globalWishlist = [];

void main() {
  runApp(const PerfumeApp());
}

class PerfumeApp extends StatelessWidget {
  const PerfumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ecommerceperfume',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),
      home: const WaveScreen(), 
    );
  }
}

//--WELCOME SCREEN

class WaveScreen extends StatelessWidget {
  const WaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Soft Essence.png',
             width: 150, height: 60),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GetstartPage()),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}



