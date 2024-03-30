import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:provider/provider.dart';
import 'package:shoping_cart_app/Views/cart_screen.dart';
import 'package:shoping_cart_app/cart_provider.dart';
import 'package:shoping_cart_app/db_helper.dart';

import '../cart_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkYM02hGwrbH-myDi0vvVnHVP8nX8yQOJ7BOfbwlkwYA&s',
    'https://hips.hearstapps.com/hmg-prod/images/orange-1558624428.jpg',
    'https://images.indianexpress.com/2021/02/grapes-1200.jpg',
    'https://fruitboxco.com/cdn/shop/products/asset_2_grande.jpg?v=1571839043',
    'https://www.shutterstock.com/image-photo/red-sweet-cherry-isolated-on-600nw-1775005853.jpg',
    'https://www.truebasics.com/blog/wp-content/uploads/2023/09/peach-benefits-for-skin.jpg',
    'https://4.imimg.com/data4/UO/US/MY-1655056/0-500x500.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text("Product List"), centerTitle: true, actions: [
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
          child: Center(
            child: Badge.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                badgeAnimation: Badge.BadgeAnimation.slide(
                    animationDuration: Duration(seconds: 2)),
                child: Icon(Icons.shopping_cart)),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: productName.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRect(
                            child: Image.network(productImage[index]),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productName[index].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productUnit[index].toString() +
                                  r" $" +
                                  productPrice[index].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  dbHelper!
                                      .insert(Cart(
                                          id: index,
                                          productId: index.toString(),
                                          productName:
                                              productName[index].toString(),
                                          initialPrice: productPrice[index],
                                          productPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag:
                                              productUnit[index].toString(),
                                          image:
                                              productImage[index].toString()))
                                      .then((value) {
                                    cart.addTotalPrice(double.parse(
                                        productPrice[index].toString()));
                                    cart.addCounter();
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                      child: Text(
                                    "Add to cart",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      ),
    ));
  }
}
