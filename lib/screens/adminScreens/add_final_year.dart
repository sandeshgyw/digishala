import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FinalYear extends StatefulWidget {
  const FinalYear({Key key}) : super(key: key);

  @override
  _FinalYearState createState() => _FinalYearState();
}

class _FinalYearState extends State<FinalYear> {
  int year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Subject",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: fieldText,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value == "")
                        return "Mandatory Field";
                      return null;
                    },
                    decoration: new InputDecoration(
                      alignLabelWithHint: true,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30),
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.book,
                      ),
                      labelText: "Year",
                    ),
                    onChanged: (value) {
                      year = int.parse(value);
                    },
                  ),
                ),
              ),
              CustomButton(
                text: "Save",
                onPress: () async {
                  await firebase.addFinalYear(year);
                  Navigator.pop(context);
                },
                color: Color(0xff6B705C),
                margin: EdgeInsets.all(8),
              ),
            ],
          ),
        ));
  }
}
