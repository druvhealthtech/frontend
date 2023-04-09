import 'package:druvtech/utils/apis/api_service.dart';
import 'package:druvtech/screens/abha_otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:druvtech/res/custom_colors.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:govt_documents_validator/govt_documents_validator.dart';

class create_ABHA_from_aadhar extends StatefulWidget {
  const create_ABHA_from_aadhar({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _create_ABHA_from_aadharState createState() =>
      _create_ABHA_from_aadharState();
}

class _create_ABHA_from_aadharState extends State<create_ABHA_from_aadhar> {
  var _formKey = GlobalKey<FormState>();
  late bool isAadharNum;
  late User _user;
  AadharValidator aadharValidator = new AadharValidator();

  String aadhar = '';
  bool isAPICallProcess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();

    APIService.otpLogin(aadhar).then(
      (response) async {
        setState(() {
          isAPICallProcess = false;
        });

        if (response.txnId != null) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AbhaOtpScreen(
                user: _user,
                aadhar: aadhar,
                txnId: response.txnId,
              ),
            ),
            // (route) => false,
          );
        }
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitle(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  maxLength: 12,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    labelText: 'Aadhar Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if (aadharValidator.validate(value) == true) {
                      aadhar = value.toString();
                      return null;
                    }
                    return "Incorrect Aadhar Number";
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text(
                    "Verify and Submit",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () => _submit(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
