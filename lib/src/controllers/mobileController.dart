import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/user_repository.dart';

class MobileController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController tcontroller = TextEditingController();
  SharedPreferences prefs;
  bool sent = false;
  MobileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  Future sendOtp(String phone) async {
    prefs = await SharedPreferences.getInstance();
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var otp = min + randomizer.nextInt(max - min);
    String url =
        "http://www.onextelbulksms.in/shn/api/pushsms.php?usr=623989&key=010Fj720jkaajKPsbJRF1IhsEwMvP1&sndr=TXTSMS&ph=$phone&text=Your Otp is $otp";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      prefs.setString('otp', otp.toString());
      prefs.setString("mobile", phone);
      Navigator.pushNamed(context, "/MobileVerification2", arguments: phone);
    }
  }

  verifyOtp() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.get("otp") == tcontroller.text) {
      currentUser.value.phone = await prefs.get("mobile");
      prefs.remove('otp');
      Fluttertoast.showToast(
          msg: "Verification done.", gravity: ToastGravity.TOP);
      Navigator.pushNamed(context, "/Settings");
    } else {
      prefs.remove('mobile');
      Fluttertoast.showToast(
          msg: "Otp not matched.", gravity: ToastGravity.TOP);
    }
  }
}
