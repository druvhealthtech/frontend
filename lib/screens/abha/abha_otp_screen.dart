import 'package:druvtech/utils/apis/api_service.dart';
import 'package:druvtech/screens/abha/check_mobile_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:druvtech/res/custom_colors.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'create_abha_screen.dart';

class AbhaOtpScreen extends StatefulWidget {
  final String? aadhar;
  final String? txnId;

  const AbhaOtpScreen({Key? key, this.aadhar, this.txnId, String? otp})
      : super(key: key);

  @override
  _AbhaOtpScreenState createState() => _AbhaOtpScreenState();
}

class _AbhaOtpScreenState extends State<AbhaOtpScreen> {
  String _otpCode = "";
  final int _otpCodeLength = 6;
  bool isAPICallProcess = false;

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    SmsAutoFill().listenForCode.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: const AppBarTitle(),
        ),
        body: ProgressHUD(
          child: verifyOtpUI(),
          inAsyncCall: isAPICallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Route _routeToMobileLinked() {
    Navigator.pop(context);
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MobileLinkedScreen(txnId: widget.txnId),
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

  Route _routeToCreate_ABHA_from_aadhar() {
    Navigator.pop(context);
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CreateABHA(),
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
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  verifyOtpUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          '/assets/otp.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              "OTP Verification",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Enter OTP sent to mobile number\n linked with ${widget.aadhar}",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                colorBuilder: FixedColorBuilder(Colors.white.withOpacity(.3))),
            currentCode: _otpCode,
            codeLength: _otpCodeLength,
            onCodeChanged: (code) {
              if (code!.length == _otpCodeLength) {
                _otpCode = code;
                // otp = _otpCode;
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton(
            "Verify",
            () {
              setState(() {
                isAPICallProcess = true;
              });

              APIService.verifyOTP(
                widget.txnId.toString(),
                _otpCode,
              ).then(
                (response) async {
                  setState(() {
                    isAPICallProcess = false;
                  });

                  if (response.txnId != null) {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      "Dhruv Tech",
                      "Verification Successfull !!",
                      "OK",
                      () {
                        // Get.offAll(_routeToUserInfo());
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          _routeToMobileLinked(),
                        );
                      },
                    );
                  } else {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      "Dhruv Tech",
                      "Invalid OTP !!",
                      "OK",
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          _routeToCreate_ABHA_from_aadhar(),
                        );
                      },
                    );
                  }
                },
              );
            },
            borderColor: HexColor("#78D0B1"),
            btnColor: HexColor("#78D0B1"),
            txtColor: HexColor("#000000"),
            borderRadius: 20,
          ),
        ),
      ],
    );
  }
}
