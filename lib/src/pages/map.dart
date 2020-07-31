import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';

import '../models/route_argument.dart';
import '../elements/CaregoriesCarouselWidget.dart';

class MapWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapWidget({Key key, this.routeArgument, this.parentScaffoldKey})
      : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  HomeController _con;

  _MapWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        title: Text(
          "Categories",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: CategoriesCarouselWidget(
        categories: _con.categories,
      ),
    );
  }
}
