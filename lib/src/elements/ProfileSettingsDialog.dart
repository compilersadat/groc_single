import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/controllers/mobileController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileSettingsDialog extends StatefulWidget {
  final User user;
  final VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends StateMVC<ProfileSettingsDialog> {
  TextEditingController pcontroller;

  MobileController _con;

  _ProfileSettingsDialogState() : super(MobileController()) {
    _con = controller;
  }
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    pcontroller = TextEditingController(text: widget.user.phone);
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).profile_settings,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: '+91 800 000 0000',
                            labelText: S.of(context).phone,
                          ),
                          controller: pcontroller,
                          // initialValue: widget.user.phone,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_phone
                              : null,
                          onSaved: (input) => widget.user.phone = input,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Visibility(
                              child: MaterialButton(
                                child: Text(
                                  "send otp",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                onPressed: () {
                                  _con.sendOtp(pcontroller.text);
                                },
                              ),
                            )
                          ],
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).john_doe,
                              labelText: S.of(context).full_name),
                          initialValue: widget.user.name,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_full_name
                              : null,
                          onSaved: (input) => widget.user.name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              hintText: 'johndo@gmail.com',
                              labelText: S.of(context).email_address),
                          initialValue: widget.user.email,
                          validator: (input) => !input.contains('@')
                              ? S.of(context).not_a_valid_email
                              : null,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).your_address,
                              labelText: S.of(context).address),
                          initialValue: widget.user.address,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_address
                              : null,
                          onSaved: (input) => widget.user.address = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).your_biography,
                              labelText: S.of(context).about),
                          initialValue: widget.user.bio,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_biography
                              : null,
                          onSaved: (input) => widget.user.bio = input,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
