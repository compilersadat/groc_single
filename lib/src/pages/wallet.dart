import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../repository/user_repository.dart';
import '../helpers/app_config.dart' as config;
import '../controllers/wallet_controller.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:math' show Random;

class WalletWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  WalletWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _WalletWidgetState createState() => _WalletWidgetState();

}
class _WalletWidgetState extends StateMVC<WalletWidget> {
  WalletController _con;
  _WalletWidgetState() : super(WalletController()) {
    _con = controller;
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  void initState() {
    super.initState();
    if(currentUser.value.apiToken != null) {
      _con.fetchWallet();
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  void openCheckout(moneya) async {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = double.parse(moneya);
    double tMoney = money*100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    var randomizer = new Random(); // can get a seed as a parameter

    // Integer between 0 and 100 (0 can be 100 not)
    var num = randomizer.nextInt(1000);
    var options = {
      'key': 'rzp_test_1ZEZsIyVwp9WtX',
      'amount': totalMoney,
      'name': _con.user.name,

      'description': 'Wallet Deposit',
      'prefill': { 'email': _con.user.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
   _con.depositAmount(amount);
   Navigator.pop(context);
   _con.scaffoldKey.currentState?.showSnackBar(
     SnackBar(
       content: Text("Money Deposited."),
     )
   );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    _con.scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(response.code.toString() ),
        )
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    _con.scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(response.walletName ),
        )
    );
  }
  var amount;
  Widget build(BuildContext context) {

    final list=ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _con.wallet_transactions.length,
        itemBuilder: (BuildContext context, int index){
          var item=_con.wallet_transactions[index]['points'].toString();
          var date=_con.wallet_transactions[index]['date'].toString();
          var type=_con.wallet_transactions[index]['type'].toString();
          return Container(
            margin:EdgeInsets.symmetric(vertical: 5),
            decoration:  BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Theme.of(context).hintColor.withOpacity(0.08),
              )
            ]),
            child:ListTile(
              leading:type=="out"?Icon(Icons.minimize,color: Colors.red,):Icon(Icons.add,color: Colors.green,),
              title: Text("${item} p"),
              trailing: Text(date) ,
            )
          );


        });
    return
    Scaffold(
      key: _drawerKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _drawerKey.currentState.openDrawer()
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "wallet",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
        body: currentUser.value.apiToken == null
            ? PermissionDeniedWidget()
            :Stack(
          children: <Widget>[

            Positioned(
              top:MediaQuery.of(context).size.height/7,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                width: config.App(context).appWidth(100),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Latest Transactions ",style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 10,),
                    _con.wallet_transactions.isEmpty? Text('No Transactions.'):
                        list
                  ],
                )
              ),
            ),

            Positioned(
              top:MediaQuery.of(context).size.height/15,
              child:  Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    color: Theme.of(context).hintColor.withOpacity(0.08),
                  )
                ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                width: config.App(context).appWidth(80),
                padding: EdgeInsets.all(20),
                child: _con.wall==null ? Text('You Not Have Any Points'):Text("${_con.wall['points'].toString()}p",style: Theme.of(context).textTheme.headline2.merge(TextStyle(fontSize:30 )),textAlign: TextAlign.center,),
              ),
            )

          ],
        ),

        floatingActionButton: currentUser.value.apiToken != null
            ? FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20.0)), //this right here
                  child: Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(

                                hintText: 'Enter Amount To Deposit.'),
                            keyboardType: TextInputType.number,
                            onChanged: (value){
                              setState(() {
                                amount=value;
                              });
                            },
                          ),
                          SizedBox(height: 30,),
                          SizedBox(
                            width: 320.0,
                            child: BlockButtonWidget(
                              text: Text(
                                "Pay Online",
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                //print(amount);
                               openCheckout(amount);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
          child: Icon(Icons.add,color: Colors.white,),
       ):null

    );
  }
}