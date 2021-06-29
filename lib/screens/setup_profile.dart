import 'dart:io';

import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:digishala/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({Key key}) : super(key: key);

  @override
  _SetupProfileState createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  GlobalKey<FormState> _formKey = GlobalKey();
  AppUser user = firebase.appUser;
  File _image;
  bool loading = false;
  Future<File> getImageFromSource(source) async {
    return File((await ImagePicker().getImage(source: source)).path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Profile"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var image =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  setState(() {
                    _image = File(image.path);
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 100,
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                            ),
                            Text("Tap to add")
                          ],
                        )
                      : ClipOval(
                          child: Image.file(
                            _image,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                        Icons.person,
                      ),
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      user.name = value;
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropdownButtonFormField<UserLevel>(
                  style: fieldText,

                  validator: (value) {
                    if (value == null) return "Mandatory Field";
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
                      Icons.lock,
                    ),
                    labelText: "Level",
                  ),
                  isExpanded: true,
                  // hint: Text("Select item"),
                  // value: user.level,
                  onChanged: (UserLevel value) {
                    setState(() {
                      user.level = value;
                    });
                  },
                  items: UserLevel.values.map((UserLevel user) {
                    return DropdownMenuItem<UserLevel>(
                        value: user,
                        child: Text(
                          user.toString().split("UserLevel.")[1],
                        ));
                  }).toList(),
                ),
              ),
              if (user.level == UserLevel.STUDENT) ...[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: fieldText,
                      validator: (value) {
                        if (value == null || value == "")
                          return "Mandatory Field";
                        return null;
                      },
                      textCapitalization: TextCapitalization.characters,
                      decoration: new InputDecoration(
                        alignLabelWithHint: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.school_outlined,
                        ),
                        labelText: "Faculty",
                      ),
                      onChanged: (value) {
                        user.faculty = value;
                      },
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: fieldText,
                      validator: (value) {
                        if (value == null || value == "")
                          return "Mandatory Field";
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                        // fillColor: Theme.of(context).primaryColor,
                        hoverColor: Theme.of(context).primaryColor,
                        focusColor: Theme.of(context).primaryColor,
                        // alignLabelWithHint: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.date_range,
                        ),
                        labelText: "Batch",
                      ),
                      onChanged: (value) {
                        user.year = int.parse(value);
                      },
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: fieldText,
                      validator: (value) {
                        if (value == null || value == "")
                          return "Mandatory Field";
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                        alignLabelWithHint: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.format_list_numbered,
                        ),
                        labelText: "Roll Number",
                      ),
                      onChanged: (value) {
                        user.roll = int.parse(value);
                      },
                    ),
                  ),
                ),
              ],
              FloatingActionButton.extended(
                icon: null,
                label: loading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      )
                    : Text(
                        "Complete Profile",
                      ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      loading = true;
                    });
                    if (_image == null) {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          showCustomSnackBar(Text("Image is mandatory")));
                    } else {
                      await firebase.saveProfile(user, _image);
                      navigateUser(context);
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
