import 'package:druvtech/providers/firebase_auth_methods.dart';
import 'package:druvtech/res/variables.dart';
import 'package:druvtech/screens/form_screen.dart';
import 'package:druvtech/screens/home_screen.dart';
import 'package:druvtech/screens/login_email_password_screen.dart';
import 'package:druvtech/screens/login_screen.dart';
import 'package:druvtech/screens/phone_screen.dart';
import 'package:druvtech/screens/signup_email_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:druvtech/firebase_options.dart';
import 'package:provider/provider.dart';
import 'utils/apis/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Druv Tech',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
        ),
        home: const AuthWrapper(),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
          // CreateABHA.routeName: (context) => const CreateABHA(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      // String? token = '';

      APIService.patientLoginDetails(
        firebaseUser.email.toString(),
      ).then(
        (response) async {
          token = response.token;
          // print(token);
          // if (response.token != null) {
          // print(response.token);
          // print(token);
          // return const FormScreen(token: response.token!);
          // Navigator.pop(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const FormScreen(token: response.token)),
          // );
          // } else {
          // Navigator.pop(context);
          // Navigator.of(context).pushReplacement(_routeToMobileLinked());
          // }
        },
      );

      return const FormScreen();
    }

    return const LoginScreen();
  }
}
