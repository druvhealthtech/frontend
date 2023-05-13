import 'dart:async';
import 'package:druvtech/utils/apis/api_service.dart';
import 'package:druvtech/screens/user_info_screen.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/firebase_auth_methods.dart';
import '../../res/custom_colors.dart';

class ABHAForm extends StatefulWidget {
  final String? txnId;
  const ABHAForm({Key? key, this.txnId}) : super(key: key);

  @override
  _ABHAFormState createState() => _ABHAFormState();
}

class _ABHAFormState extends State<ABHAForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: const AppBarTitle(),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SignUpForm(txnId: widget.txnId),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final String? txnId;

  const SignUpForm({Key? key, this.txnId}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String _firstname = '';
  String _lastname = '';
  String _middlename = '';
  String _email = '';
  String _healthID = '';
  String _password = '';
  String _profilephotourl = '';

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return Form(
      key: _formKey,
      child: ListView(
        children: getFormWidget(user),
      ),
    );
  }

  List<Widget> getFormWidget(final user) {
    List<Widget> formWidget = [];

    formWidget.add(
      Column(
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
        ],
      ),
    );

    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          labelText: ' First Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a valid name';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(
            () {
              _firstname = value.toString();
            },
          );
        },
      ),
    );

    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          labelText: ' Middle Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a valid name';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(
            () {
              _middlename = value.toString();
            },
          );
        },
      ),
    );

    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          labelText: ' Last Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a valid name';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(
            () {
              _lastname = value.toString();
            },
          );
        },
      ),
    );

    validateEmail(String? value) {
      if (value!.isEmpty) {
        return 'Please enter mail';
      }

      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value.toString())) {
        return 'Enter Valid Email';
      } else {
        return null;
      }
    }

    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          labelText: ' Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        onSaved: (value) {
          setState(
            () {
              _email = value.toString();
            },
          );
        },
      ),
    );

    formWidget.add(
      TextFormField(
        decoration: const InputDecoration(
          labelText: ' Health Id',
          hintText: 'FirstName_MiddleName_LastName',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a Health Id';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(
            () {
              _healthID = value.toString();
            },
          );
        },
      ),
    );

    formWidget.add(
      TextFormField(
        key: _passKey,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: ' Password',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter password';
          } else if (value.length < 8) {
            return 'Password should be more than 8 characters';
          } else {
            return null;
          }
        },
      ),
    );

    formWidget.add(
      TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          labelText: ' Confirm Password',
        ),
        validator: (confirmPassword) {
          if (confirmPassword != null && confirmPassword.isEmpty) {
            return 'Enter confirm password';
          }
          var password = _passKey.currentState?.value;
          if (confirmPassword != null &&
              confirmPassword.compareTo(password) != 0) {
            return 'Password mismatch';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(
            () {
              _password = value.toString();
            },
          );
        },
      ),
    );

    formWidget.add(
      TextFormField(
        initialValue: user.photoURL.toString(),
        readOnly: true,
        decoration: const InputDecoration(
          labelText: ' Profile Photo URL',
        ),
        onSaved: (value) {
          setState(
            () {
              _profilephotourl = user.photoURL.toString();
            },
          );
        },
      ),
    );

    void onPressedSubmit() {
      var healthID = '';

      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("\n-------------------------------------------");
        print("Name $_firstname $_middlename $_lastname");
        print("Email $_email");
        print("HealthId $_healthID");
        print("Password $_password");
        print("Profile Photo URL $_profilephotourl");
        print("-------------------------------------------\n");

        print("\n-------------------------------------------");
        APIService.createHealthIdWithPreVerified(
          _email,
          _firstname,
          _healthID,
          _lastname,
          _middlename,
          _password,
          _profilephotourl,
          widget.txnId.toString(),
        ).then(
          (response) async {
            healthID = response.healthIdNumber.toString();
            print('\n-----------------------------------------');
            print("Your health ID -> ${response.healthIdNumber}");
            print('-----------------------------------------\n');
          },
        );
        print("-------------------------------------------\n");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form Submitted'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Timer(
          const Duration(seconds: 2),
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInfoScreen(
                  healthIdNumber: healthID,
                ),
              ),
            );
          },
        );
      }
    }

    formWidget.add(
      const SizedBox(
        height: 30,
      ),
    );

    formWidget.add(
      ElevatedButton(
        onPressed: onPressedSubmit,
        child: const Text(' Submit '),
      ),
    );

    return formWidget;
  }
}
