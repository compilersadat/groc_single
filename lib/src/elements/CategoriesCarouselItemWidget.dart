import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  String route;
  CategoriesCarouselItemWidget(
      {Key key, this.marginLeft, this.category, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed(route,
            arguments: RouteArgument(id: category.id, name: category.name));
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: 7.0)
              ]),
          child: category.image.url.toLowerCase().endsWith('.svg')
              ? SvgPicture.network(
                  category.image.url,
                  color: Theme.of(context).accentColor,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: category.image.icon,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          title: Text(
            category.name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
