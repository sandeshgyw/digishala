import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digishala/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class _Firebase {
  FirebaseAuth _firebaseAuth;
  User firebaseUser;
  AppUser appUser;
  FirebaseMessaging _messaging;
  FirebaseFirestore _firestore;
  FirebaseStorage _storage;

  initialize() async {
    await Firebase.initializeApp();
    _firebaseAuth = FirebaseAuth.instance;
    firebaseUser = _firebaseAuth.currentUser;
    _messaging = FirebaseMessaging.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    if (firebaseUser != null) {
      appUser = await getMyUserModel();
      // updateLastOnlineStatus();
      uploadToken(appUser);
    }
  }

  sendPhoneCode(
    String countryCode,
    String phone, {
    Function(String, [int]) onSent,
    Function(FirebaseException) onFailed,
    Function(AppUser) onCompleted,
    Function(String) autoRetrivalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+$countryCode" + phone,
      timeout: Duration(minutes: 1),
      verificationCompleted: (AuthCredential auth) async {
        onCompleted(await verifyCode(
          auth,
          countryCode,
        ));
      },
      verificationFailed: onFailed,
      codeSent: onSent,
      codeAutoRetrievalTimeout: (autoRetrivalTimeout) {},
    );
  }

  Future<AppUser> verifyCode(
    AuthCredential auth,
    String countryCode,
  ) async {
    firebaseUser = (await _firebaseAuth.signInWithCredential(auth)).user;
    // uploadToken();
    return getMyUserModel(
      countryCode: countryCode,
    );
  }

  Future<AppUser> getMyUserModel({String countryCode}) async {
    var userRef = _firestore.collection("users").doc(firebaseUser.uid);
    var userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      AppUser model = AppUser.fromMap(userSnapshot.data());
      return appUser = model;
    } else {
      AppUser userModel = AppUser()
        ..phoneNumber = firebaseUser.phoneNumber
        ..profileCreated = false
        ..isVerified = false
        ..token = await _messaging.getToken()
        ..uid = firebaseUser.uid;
      // await userRef.set(userModel.toMap());
      return appUser = userModel;
    }
  }

  Future<void> saveProfile(AppUser user, File image) async {
    user.profileCreated = true;
    Reference ref = _storage
        .ref()
        .child(user.faculty)
        .child(user.year.toString())
        .child(user.roll.toString());
    UploadTask task = ref.putFile(image);
    await task;
    user.imageUrl = await ref.getDownloadURL();
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  uploadToken(AppUser user) async {
    String token = await _messaging.getToken();
    await _firestore.collection("users").doc(user.uid).set(
      {"token": token},
      SetOptions(merge: true),
    );
  }
}

_Firebase firebase = _Firebase();
