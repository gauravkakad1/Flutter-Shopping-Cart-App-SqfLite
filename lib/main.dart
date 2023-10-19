import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cart_app/cart_provider.dart';

import 'Views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=>CartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(
            title: 'Shoping Cart App',
            theme: ThemeData(primarySwatch: Colors.amber),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen()
        );
      }),
    );
  }
}
