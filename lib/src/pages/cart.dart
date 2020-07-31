import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    _con.getPromos(_con.total);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prom=_con.promos==null?Text('No Promo Codes'):ListView.separated(
    scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
    itemCount: _con.promos.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 15);
        },
        itemBuilder: (BuildContext context, int index){
          var item=_con.promos[index]['code'].toString();
          var id=_con.promos[index]['id'].toString();
          var disc=_con.promos[index]['discount'].toString();
          var type=_con.promos[index]['type'].toString();
          var status=_con.promos[index]['status'].toString();
          return Container(

              decoration:  BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Theme.of(context).hintColor.withOpacity(0.08),
                )
              ]),
              child:ListTile(
                leading:Icon(Icons.card_giftcard,color: Colors.red),
                title: Row(
                  children: <Widget>[
                    Text('${item}'),
                    SizedBox(width: 10,),
                    Text('${disc}'),
                    type=="flat"?Text("p"):Text("%"),
                  ],
                ),
                subtitle:status=="1"?  Text("Discount will be added in your dailymaart wallet."):Text(""),
                trailing:status=="0"? InkWell(
                  onTap: (){
                   _con.apply(id,_con.total);
                  },
                  child: Text('Apply Now',style: TextStyle(color: Colors.green),),
                ):Text("Applied",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
              )
          );


        }
    );
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument.param == '/Product') {
                Navigator.of(context).pushReplacementNamed('/Product', arguments: RouteArgument(id: widget.routeArgument.id));
              } else {
                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
              }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Container(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    children: <Widget>[



                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).shopping_cart,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S.of(context).verify_your_quantity_and_click_checkout,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.carts.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, index) {
                          return CartItemWidget(
                            cart: _con.carts.elementAt(index),
                            heroTag: 'cart',
                            increment: () {
                              _con.incrementQuantity(_con.carts.elementAt(index));
                            },
                            decrement: () {
                              _con.decrementQuantity(_con.carts.elementAt(index));
                            },
                            onDismissed: () {
                              _con.removeFromCart(_con.carts.elementAt(index));
                            },
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Available Promo Codes",style: Theme.of(context).textTheme.headline4,),
                      ),
                      SizedBox(height: 20,),
                      prom,

                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
