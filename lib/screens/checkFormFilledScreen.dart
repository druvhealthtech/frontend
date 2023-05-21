import 'package:druvtech/screens/form_screen.dart';
import 'package:druvtech/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckFormFilledScreen extends StatefulWidget {
  const CheckFormFilledScreen({Key? key}) : super(key: key);

  @override
  _CheckFormFilledScreenState createState() => _CheckFormFilledScreenState();
}

class _CheckFormFilledScreenState extends State<CheckFormFilledScreen> {
  // Add any necessary variables and state here
  late bool _isFormFilled = false;
  void checkIsFormFilled() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isFormFilled = prefs.getBool('isFormFilled');
    print(isFormFilled);
    // const isFormFilled = false;
    setState(() => {
          if (isFormFilled == null || !isFormFilled)
            {_isFormFilled = false}
          else
            {_isFormFilled = true}
        });
  }

  @override
  void initState() {
    super.initState();
    checkIsFormFilled();
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI for the screen here
    if (_isFormFilled == false) {
      return const FormScreen();
    } else {
      return const HomeScreen();
    }
  }
}
