import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final facebookLogin = FacebookLogin();
  Future<void> fbLogin() async {
    final result = await facebookLogin.logIn(['email']);
    print(result);
    FocusScope.of(context).unfocus();
    Overlay.of(context).insert(loader);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        var name = profile.name;
        var email = profile.email;
        FocusScope.of(context).unfocus();
        Overlay.of(context).insert(loader);
        repository.gLogin(name, email).then((value) {
          if (value != null && value.apiToken != null) {
            Navigator.of(scaffoldKey.currentContext)
                .pushReplacementNamed('/Pages', arguments: 2);
          } else {
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(S.of(context).wrong_email_or_password),
            ));
          }
        }).catchError((e) {
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).this_account_not_exist),
          ));
        }).whenComplete(() {
          Helper.hideLoader(loader);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Cancelled By You."),
        ));
        break;
      case FacebookLoginStatus.error:
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Something Went Wrong"),
        ));
        break;
    }
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn
          .signIn()
          .then((result) => result.authentication.then((googleKey) {
                var name = _googleSignIn.currentUser.displayName;
                var email = _googleSignIn.currentUser.email;
                FocusScope.of(context).unfocus();
                Overlay.of(context).insert(loader);
                repository.gLogin(name, email).then((value) {
                  if (value != null && value.apiToken != null) {
                    Navigator.of(scaffoldKey.currentContext)
                        .pushReplacementNamed('/Pages', arguments: 2);
                  } else {
                    scaffoldKey?.currentState?.showSnackBar(SnackBar(
                      content: Text(S.of(context).wrong_email_or_password),
                    ));
                  }
                }).catchError((e) {
                  loader.remove();
                  scaffoldKey?.currentState?.showSnackBar(SnackBar(
                    content: Text(S.of(context).this_account_not_exist),
                  ));
                }).whenComplete(() {
                  Helper.hideLoader(loader);
                });
              }).catchError((e) {
                loader.remove();
                scaffoldKey?.currentState?.showSnackBar(SnackBar(
                  content: Text("Some thing Went Wrong"),
                ));
              }))
          .catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Some thing Went Wrong"),
        ));
      });
    } catch (error) {
      loader.remove();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(error),
      ));
    }
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
