import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:digishala/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber, code, token, faculty, year;
  UserLevel level;
  GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });
      FocusScope.of(context).unfocus();
      // setLoading(true);
      if (phoneNumber.length != 10) {
        SnackBar(content: Text("Enter a valid 10 digit number."));
        // setLoading(false);
      } else {
        firebase.sendPhoneCode("+977", phoneNumber, onSent: (a, [b]) {
          setState(() {
            token = a;
            loading = false;
          });
          // logEvent("code_sent");
          // setLoading(false);
        }, onCompleted: (AppUser user) {
          // setLoading(false);
          navigateUser(context);
        }, onFailed: (e) {
          ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              Text("Invalid Phone Number.Please try Again")));
          setState(() {
            loading = false;
          });
          // setLoading(false);
          // showCustomSnackBar(
          //   context: context,
          //   text: e.message,
          // );
        });
      }
    }
  }

  verifyPhone() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });

      // setLoading(true);
      AuthCredential phoneAuth = PhoneAuthProvider.credential(
        verificationId: token,
        smsCode: code,
      );
      firebase.verifyCode(phoneAuth, "+977").then((u) {
        // logEvent("code_verified");
        // setLoading(false);
        setState(() {
          loading = false;
        });
        navigateUser(context);
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(showCustomSnackBar(Text("Invalid Code")));
        setState(() {
          loading = false;
        });
        // logEvent("verification_failed");
        // setLoading(false);
      });
    }
  }

  FocusNode focusNode = FocusNode();
  Widget enterCode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
          child: PinCodeTextField(
            validator: (value) {
              if (value == null || value == "") return "Mandatory Field";
              if (value.length < 6) return "OTP must be 6 digits long";
              return null;
            },
            length: 6,
            appContext: context,
            // backgroundColor: Theme.of(context).backgroundColor,
            onChanged: (value) {},
            autoFocus: true,
            keyboardType: TextInputType.phone,
            animationType: AnimationType.fade,
            enableActiveFill: true,
            autoDismissKeyboard: true,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                // activeColor: primaryColor,
                activeFillColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white),
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            onCompleted: (code) {
              this.code = code;
              verifyPhone();
            },
          ),
        ),
        SizedBox(height: 20),
        FloatingActionButton.extended(
          icon: null,
          label: loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Text("Verify"),
          onPressed: verifyPhone,
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            setState(() {
              token = null;
            });
          },
          child: Text("Not your number?"),
        ),
      ],
    );
  }

  Widget enterPhone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: fieldText,
              validator: (value) {
                if (value == null || value == "") return "Mandatory Field";
                if (value.length < 10)
                  return "Please enter a valid 10 digit number";
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                  // fillColor: Theme.of(context).primaryColor,
                  alignLabelWithHint: true,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    color: Theme.of(context).primaryColor,
                  ),
                  prefix: Text(
                    "+977 ",
                    style: fieldText,
                  ),
                  hintText: "Enter Your Phone Number...",
                  hintStyle: fieldText),
              onChanged: (value) {
                phoneNumber = value;
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        FloatingActionButton.extended(
          label: loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  "Continue",
                  // style: normalText,
                ),
          icon: null,
          onPressed: login,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              // color: Colors.blue,
              child: Image.asset(
                    "assets/logoo.png",
                    fit: BoxFit.fill,
                  ) ??
                  Icon(Icons.ac_unit),
            ),
            if (token == null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                ),
                child: Text(
                  "Enter you details to start the login process.",
                ),
              ),
              SizedBox(height: 10),
              enterPhone()
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Please enter the code sent to +977-$phoneNumber via SMS.",
                ),
              ),
              SizedBox(height: 10),
              enterCode()
            ],
          ],
        ),
      )),
    );
  }
}
