import 'package:flutter/material.dart';
import 'package:markets/src/models/sub_category.dart';
import 'package:markets/src/pages/mobile_verification.dart';
import 'package:markets/src/pages/mobile_verification_2.dart';

import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/category.dart';
import 'src/pages/checkout.dart';
import 'src/pages/debug.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/delivery_pickup.dart';
import 'src/pages/details.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/menu_list.dart';
import 'src/pages/order_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
import 'src/pages/paypal_payment.dart';
import 'src/pages/product.dart';
import 'src/pages/profile.dart';
import 'src/pages/razorpay_payment.dart';
import 'src/pages/reviews.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';
import 'src/pages/wallet.dart';
import 'src/pages/sub_category.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(
            builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => MobileVerification());
      case '/MobileVerification2':
        return MaterialPageRoute(
            builder: (_) => MobileVerification2(
                  phone: args,
                ));
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Details':
        return MaterialPageRoute(
            builder: (_) => DetailsWidget(routeArgument: args));
      case '/Menu':
        return MaterialPageRoute(
            builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Product':
        return MaterialPageRoute(
            builder: (_) =>
                ProductWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(
            builder: (_) =>
                TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(
            builder: (_) =>
                ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(
            builder: (_) =>
                DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Cash on Delivery')));
      case '/PayOnPickup':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Pay on Pickup')));
      case '/MartWallet':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'DailyMaart wallet')));

      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) =>
                PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/RazorPay':
        return MaterialPageRoute(
            builder: (_) =>
                RazorPayPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(
            builder: (_) =>
                OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Wallet':
        return MaterialPageRoute(builder: (_) => WalletWidget());
      case '/SubCategory':
        return MaterialPageRoute(
            builder: (_) =>
                SubCategoryWidget(routeArgument: args as RouteArgument));

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
