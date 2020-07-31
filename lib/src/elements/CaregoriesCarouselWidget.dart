import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : GridView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemCount: this.categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1),
            itemBuilder: (context, index) => CategoriesCarouselItemWidget(
              marginLeft: 0,
              category: this.categories.elementAt(index),
              route: '/SubCategory',
            ),
          );
  }
}
