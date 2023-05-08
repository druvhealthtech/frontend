import 'package:druvtech/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('/assets/doctor.gif'),
            fit: BoxFit.contain,
          ),
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     settings: const RouteSettings(name: "/LoginScreen"),
            //     builder: (context) => const LoginScreen(),
            //   ),
            // );
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(50),
              textStyle: const TextStyle(fontSize: 100)),
          child: const Text(
            "Let's revolutionize health tech !!",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
