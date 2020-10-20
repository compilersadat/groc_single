import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/sub_category.dart';
import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../helpers/helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoryController extends ControllerMVC {
  final List<SubCategory> subcats = <SubCategory>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  bool loadCart = false;
  List<Cart> carts = [];
  SubCategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<Stream<SubCategory>> getSubCat(id) async {
    Uri uri = Helper.getUri('api/sub_categories/$id');
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => (Helper.getDataS(e) as List))
        .map((data) => SubCategory.fromJson(data));
  }

  void ListenForSubCat(id) async {
    final Stream<SubCategory> stream = await getSubCat(id);
    stream.listen((SubCategory _product) {
      setState(() {
        subcats.add(_product);
      });
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {});
  }
}
