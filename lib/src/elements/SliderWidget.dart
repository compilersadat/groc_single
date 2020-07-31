import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../helpers/helper.dart';
// ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
   List slides = List();
   String uri;
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
  SliderWidget({Key key,@required this.slides,@required this.uri}) : super(key: key);
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: new Duration(seconds: 3),
        viewportFraction: 0.7,
        initialPage: 0,
        height: 180.0,
        enlargeCenterPage: true
      ),
      
      items: widget.slides.map((data) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Card(

                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(

                  fit: BoxFit.cover,
                  imageUrl: widget.uri+data['image'],
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

