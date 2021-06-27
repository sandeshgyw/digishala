import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digishala"),
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          // Expanded(
          //   child: Container(
          //     color: Colors.blue,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30),
                  ),
                ),
                filled: true,
                prefixIcon: Icon(
                  Icons.phone_iphone,
                ),
                hintText: "Enter Your Phone Number...",
              ),
              onChanged: (value) {
                // phoneNumber = value;
              },
            ),
          ),
        ],
      )),
    );
  }
}
