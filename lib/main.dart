import 'package:eshop/helper/custom_route.dart';
import 'package:eshop/provider/auth_provider.dart';
import 'package:eshop/provider/order_provider.dart';
import 'package:eshop/provider/products_provider.dart';
import 'package:eshop/screens/auth_screen.dart';
import 'package:eshop/screens/cart_screen.dart';
import 'package:eshop/screens/edit_product_screen.dart';
import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/screens/product_details_screen.dart';
import 'package:eshop/screens/product_overview_screen.dart';
import 'package:eshop/screens/user_product_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/cart_provider.dart';
import 'package:custom_splash/custom_splash.dart';

Future<void> main() async {
  // widgets initialize
  WidgetsFlutterBinding.ensureInitialized();
  //firebase app initialize
  await Firebase.initializeApp();
  runApp(SplashClass());
}

class SplashClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
            create: (context) => Products("", "", []),
            update: (context, AuthProvider auth, Products previousProducts) {
              return Products(auth.token, auth.userId,
                  previousProducts == null ? [] : previousProducts.items);
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (context) => Orders("", "", []),
          update: (context, AuthProvider auth, Orders previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Shop',
        theme: ThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.red,
            fontFamily: "Lato",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })),
        home: MyApp(),
        routes: {
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen()
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInit = true;
  bool _isLogin = false;
  Map<int, Widget> output = {1: AuthScreen(), 2: ProductOverviewScreen()};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      checkLogin();
    }
    _isInit = false;
  }

  void checkLogin() async {
    _isLogin = await Provider.of<AuthProvider>(context).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplash(
        imagePath: 'assets/images/logo.png',
        backGroundColor: Colors.pink[100],
        animationEffect: 'zoom-in',
        logoSize: 200,
        type: CustomSplashType.StaticDuration,
        duration: 2500,
        home: _isLogin ? ProductOverviewScreen() : AuthScreen());
  }
}
