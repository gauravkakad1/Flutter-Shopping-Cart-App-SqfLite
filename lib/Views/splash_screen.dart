import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shoping_cart_app/Views/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
            () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Align(
          alignment: AlignmentDirectional.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopify_sharp
                , size: 100,),
              SizedBox(height: 20),
              Text("Shop Free" ,
                style: TextStyle(fontSize: 50,fontWeight: FontWeight.w700),
              )
            ] ,
          ),
        ),
      ),
    );
  }
}
