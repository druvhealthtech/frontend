import 'package:druvtech/utils/apis/api_service.dart';
import 'package:flutter/material.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:druvtech/res/custom_colors.dart';
import 'package:flutter/services.dart';
import 'package:druvtech/screens/mobile_otp_verify.dart';
import 'abha_form_screen.dart';

class MobileLinkedScreen extends StatefulWidget {
  final String? txnId;

  const MobileLinkedScreen({
    Key? key,
    this.txnId,
  }) : super(key: key);

  @override
  _MobileLinkedScreen createState() => _MobileLinkedScreen();
}

class _MobileLinkedScreen extends State<MobileLinkedScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool isMobileNum;

  String mobile = '';
  bool isAPICallProcess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();

    APIService.CheckMobileLinked(
      mobile,
      widget.txnId!,
    ).then(
      (response) async {
        setState(() {
          isAPICallProcess = false;
        });

        if (response.mobileLinked == true) {
          // Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ABHAForm(
                txnId: widget.txnId,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileOtpScreen(
                mobile: mobile,
                txnId: response.txnId,
              ),
            ),
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
                  maxLength: 10,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: ' Mobile Number',
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
                    mobile = value.toString();
                    return null;
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
