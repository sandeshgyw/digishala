import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddFaculty extends StatefulWidget {
  const AddFaculty({Key key}) : super(key: key);

  @override
  _AddFacultyState createState() => _AddFacultyState();
}

class _AddFacultyState extends State<AddFaculty> {
  String faculty;
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
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      faculty = value;
                    },
                  ),
                ),
              ),
              CustomButton(
                text: "Add Faculty",
                onPress: () async {
                  await firebase.addFaculty(faculty);
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
