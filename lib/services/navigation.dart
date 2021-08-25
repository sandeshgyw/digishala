import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/authorized_home.dart';
import 'package:digishala/screens/login_screen.dart';
import 'package:digishala/screens/setup_profile.dart';
import 'package:digishala/screens/unauthorized_home.dart';
import 'package:digishala/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void navigateUser(BuildContext context) {
  AppUser userModel = firebase.appUser;
  User firebaseUser = firebase.firebaseUser;

  if (firebaseUser == null) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  } else if (userModel?.profileCreated == false ||
      userModel?.profileCreated == null) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SetupProfile()));
  } else if (userModel.profileCreated == true &&
      (userModel.isVerified == false || userModel.isVerified == null)) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UnAuthorizedHome()));
  } else if (userModel.isVerified == true) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AuthorizedHome())); //make it authorized home only for test
  }
}
