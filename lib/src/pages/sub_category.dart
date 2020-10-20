import 'package:flutter/material.dart';
import 'package:markets/src/models/sub_category.dart';
import '../controllers/sub_category_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../elements/SubCatItemWidget.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/DrawerWidget.dart';
import '../models/route_argument.dart';

class SubCategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
  SubCategoryWidget({Key key, this.routeArgument}) : super(key: key);
}

class _SubCategoryWidgetState extends StateMVC<SubCategoryWidget> {
  SubCategoryController _con;
  _SubCategoryWidgetState() : super(SubCategoryController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    //_con.getSubCat(widget.routeArgument.id);
    _con.ListenForSubCat(widget.routeArgument.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.routeArgument.name,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: _con.subcats.isEmpty
          ? CircularLoadingWidget(height: 150)
          : GridView.builder(
              // reverse: true,
              padding: EdgeInsets.only(left: 10, right: 10, top: 40),
              itemCount: _con.subcats.length,
              itemBuilder: (context, index) => SubCategoryItemWidget(
                category: _con.subcats[index],
                route: "/Category",
                marginLeft: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1),
            ),
    );
  }
}
