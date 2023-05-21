import 'package:druvtech/providers/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:druvtech/res/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../screens/login_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isSigningOut = false;

  Route _routeToLoginScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: CustomColors.firebaseNavy,
      //   title: const AppBarTitle(),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: CustomColors.firebaseGrey,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.displayName!,
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '( ${user.email} )',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                style: TextStyle(
                    color: CustomColors.firebaseGrey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 16.0),
              _isSigningOut
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        context.read<FirebaseAuthMethods>().signOut(context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context)
                            .pushReplacement(_routeToLoginScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Center(
                      child: QrImage(
                        data:
                            "Name: ${user.displayName}\nEmail: ${user.email}\nPhone number : ${user.phoneNumber}\n",
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(milliseconds: 10000),
                    elevation: 50,
                    width: 300,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.qr_code),
                label: const Text('Generate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
