import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/happy_ppl.png', height: 250),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFECEAFF),
                        Colors.white,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "SafeCampus",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "SafeCampus is your companion for safe walks at night. Whether you're heading home from class or a late study session, we’ve got your back.",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text('Register'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signin');
                              },
                              child: const Text('Sign In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
