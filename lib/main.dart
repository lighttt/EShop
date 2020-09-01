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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/cart_provider.dart';

Future<void> main() async {
  // widgets initialize
  WidgetsFlutterBinding.ensureInitialized();
  //firebase app initialize
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInit = true;
  bool _isLogin = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//  Future<void> getCurrentUser() async {
//    final response = _firebaseAuth.currentUser;
//    if (response != null) {
//      //refresh the previous
//      final newToken = await response.getIdToken();
//      Provider.of<AuthProvider>(context, listen: false)
//          .updateNewToken(newToken, response.uid);
//      _isLogin = true;
//    }
//    _isLogin = false;
//  }
//
//  @override
//  void didChangeDependencies() {
//    if (_isInit) {
//      getCurrentUser();
//    }
//    _isInit = false;
//    super.didChangeDependencies();
//  }

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
              return Products(auth.authToken, auth.userId,
                  previousProducts == null ? [] : previousProducts.items);
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (context) => Orders("", "", []),
          update: (context, AuthProvider auth, Orders previousOrders) => Orders(
              auth.authToken,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Shop',
            theme: ThemeData(
                primaryColor: Colors.green,
                accentColor: Colors.red,
                fontFamily: "Lato"),
            home: auth.userId == null ? AuthScreen() : ProductOverviewScreen(),
            routes: {
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen()
            },
          );
        },
      ),
    );
  }
}
