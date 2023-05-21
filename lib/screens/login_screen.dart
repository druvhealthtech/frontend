import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firebase_auth_methods.dart';
import '../res/custom_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          // controller: controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Row(
                children: [
                  Row(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Image.asset(
                            'assets/druv_logo_round.png',
                            height: 160,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: CustomColors.firebaseYellow,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          'Druv Tech',
                          style: TextStyle(
                            color: CustomColors.firebaseOrange,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        fixedSize: const Size(250, 40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: IconButton(
                              icon: Image.asset("assets/google_logo.png"),
                              iconSize: 40.0,
                              onPressed: () {
                                context
                                    .read<FirebaseAuthMethods>()
                                    .signInWithGoogle(context);
                              },
                            ),
                          ),
                          const Text('Sign in with google')
                        ],
                      ),
                      onPressed: () {
                        context
                            .read<FirebaseAuthMethods>()
                            .signInWithGoogle(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        fixedSize: const Size(250, 40),
                      ),
                      icon: const Icon(
                        Icons.email,
                        size: 24,
                      ),
                      onPressed: null,
                      // () {
                      //   Navigator.pushNamed(
                      //       context, EmailPasswordSignup.routeName);
                      // },
                      label: const Text('Email/Password Sign Up'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        fixedSize: const Size(250, 40),
                      ),
                      icon: const Icon(
                        Icons.email_outlined,
                        size: 24,
                      ),
                      onPressed: null,
                      // () {
                      //   Navigator.pushNamed(
                      //       context, EmailPasswordLogin.routeName);
                      // },
                      label: const Text('Email/Password Login'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        fixedSize: const Size(250, 40),
                      ),
                      icon: const Icon(
                        Icons.phone_android,
                        size: 24,
                      ),
                      onPressed: null,
                      // () {
                      //   Navigator.pushNamed(context, PhoneScreen.routeName);
                      // },
                      label: const Text('Phone SignUp/SignIn'),
                    ),
                    // const SizedBox(height: 20),
                    // ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white70,
                    //     foregroundColor: Colors.black,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(32.0)),
                    //     fixedSize: const Size(250, 40),
                    //   ),
                    //   icon: const Icon(
                    //     Icons.person,
                    //     size: 24,
                    //   ),
                    //   onPressed: () {
                    //     context
                    //         .read<FirebaseAuthMethods>()
                    //         .signInAnonymously(context);
                    //   },
                    //   label: const Text('SignIn Anonymously'),
                    // ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
