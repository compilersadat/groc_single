import 'package:flutter/material.dart';
import 'package:markets/src/models/user.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../controllers/mobileController.dart';

class MobileVerification2 extends StatefulWidget {
  final String phone;
  MobileVerification2({Key key, this.phone}) : super(key: key);

  @override
  _MobileVerification2State createState() => _MobileVerification2State();
}

class _MobileVerification2State extends StateMVC<MobileVerification2> {
  MobileController _con;
  _MobileVerification2State() : super(MobileController()) {
    _con = controller;
  }
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _ac = config.App(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _ac.appWidth(100),
              child: Column(
                children: <Widget>[
                  Text(
                    'Verify Your Account',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We are sending OTP to validate your mobile number. Hang on!',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _con.tcontroller,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).focusColor.withOpacity(0.2)),
                ),
                focusedBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                    color: Theme.of(context).focusColor.withOpacity(0.5),
                  ),
                ),
                hintText: '000-000',
              ),
            ),
            SizedBox(height: 15),
            Text(
              'SMS has been sent to ${widget.phone}',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80),
            new BlockButtonWidget(
              onPressed: () {
                _con.verifyOtp();
              },
              color: Theme.of(context).accentColor,
              text: Text(S.of(context).verify.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .merge(TextStyle(color: Theme.of(context).primaryColor))),
            ),
          ],
        ),
      ),
    );
  }
}
