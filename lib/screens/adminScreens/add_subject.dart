import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key key}) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  Subject subject = Subject();
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
                      subject.name = value;
                    },
                  ),
                ),
              ),
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
                      labelText: "Faculty",
                    ),
                    onChanged: (value) {
                      subject.faculty = value;
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
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
                      subject.year = int.parse(value);
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
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
                      labelText: "Semester",
                    ),
                    onChanged: (value) {
                      subject.sem = int.parse(value);
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
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
                      labelText: "Theory Marks",
                    ),
                    onChanged: (value) {
                      subject.theoryMarks = int.parse(value);
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
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
                      labelText: "Practical Marks",
                    ),
                    onChanged: (value) {
                      subject.practicalMarks = int.parse(value);
                    },
                  ),
                ),
              ),
              CustomButton(
                text: "Add Subject",
                onPress: () async {
                  await firebase.addSubject(subject);
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
