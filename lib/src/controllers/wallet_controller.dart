import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wallet_transaction.dart';
import '../models/wallet.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../controllers/controller.dart';
class WalletController extends ControllerMVC {
  Wallet wallet = new Wallet();
  WalletTransaction wallet_transaction = new WalletTransaction();
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;
  var wall;
  var total=0.0;
  WalletController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  List wallet_transactions = List();
  User user = userRepo.currentUser.value;

  Future fetchWallet() async {
    Uri uri = Helper.getUri('api/getWallet');

    http.Response response = await http.post(uri,body: {'user_id':user.id});
    if (response.statusCode == 200) {
      var datar = json.decode(response.body);
      if(datar["status"]=="S"){

        setState((){
          wall=datar['wallet'];
          wallet_transactions=datar['transaction'];
        });
      }
    print(wall);
    }


  }
  Future depositAmount(points) async {
    Uri uri = Helper.getUri('api/depositAmount');

    http.Response response = await http.post(uri,body: {'user_id':user.id,'points':points});
    if (response.statusCode == 200) {
      var datar = json.decode(response.body);
      if(datar["status"]=="S"){

        setState((){
          wall=datar['wallet'];
          wallet_transactions=datar['transaction'];
        });
      }
      print(wall);
    }


  }

  Future getTotal() async{
    Uri uri = Helper.getUri('api/getTotal');

    http.Response response = await http.post(uri,body: {'user_id':user.id});
    if (response.statusCode == 200) {
      var datar = json.decode(response.body);
      if(datar["status"]=="S"){

        setState((){
          total=datar['total']+0.0;
        });
      }
      print(total);
    }
  }

}