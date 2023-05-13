import 'package:druvtech/utils/apis/api_service.dart';
import '../../screens/abha/abha_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:druvtech/res/custom_colors.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:govt_documents_validator/govt_documents_validator.dart';

class CreateABHA extends StatefulWidget {
  const CreateABHA({Key? key}) : super(key: key);

  @override
  _CreateABHAState createState() => _CreateABHAState();
}

class _CreateABHAState extends State<CreateABHA> {
  final _formKey = GlobalKey<FormState>();
  late bool isAadharNum;
  AadharValidator aadharValidator = AadharValidator();

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
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: const AppBarTitle(),
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
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: ' Aadhar Number',
                    // label: const Center(
                    //   child: Text('Aadhar Number'),
                    // ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if (aadharValidator.validate(value) == true) {
                      aadhar = value.toString();
                      return null;
                    }
                    return " Incorrect Aadhar Number";
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
                  child: const Text(
                    "Verify and Submit",
                    style: TextStyle(
                      fontSize: 18.0,
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
