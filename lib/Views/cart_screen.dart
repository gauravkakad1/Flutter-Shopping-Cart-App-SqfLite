import 'package:badges/badges.dart' as Badge;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cart_app/db_helper.dart';

import '../cart_model.dart';
import '../cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text("My Products"), centerTitle: true, actions: [
        Center(
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
        SizedBox(
          width: 20,
        )
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('images/empty_cart.png'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
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
                                      child: Image.network(snapshot
                                          .data![index].image
                                          .toString()),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              snapshot.data![index].productName
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16)),
                                          InkWell(
                                              onTap: () {
                                                dbHelper!.delete(
                                                    snapshot.data![index].id!);
                                                cart.removeCounter();
                                                cart.removeTotalPrice(
                                                    double.parse(snapshot
                                                        .data![index]
                                                        .productPrice
                                                        .toString()));
                                              },
                                              child: Icon(Icons.delete))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data![index].unitTag
                                                .toString() +
                                            r" $" +
                                            snapshot.data![index].productPrice
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () {
                                                    int quantity = snapshot
                                                        .data![index].quantity!;
                                                    int initialPrice = snapshot
                                                        .data![index]
                                                        .initialPrice!;
                                                    quantity--;
                                                    int newPrice =
                                                        quantity * initialPrice;
                                                    if (quantity > 0) {
                                                      dbHelper
                                                          .updateQuantity(Cart(
                                                        id: snapshot
                                                            .data![index].id,
                                                        productId: snapshot
                                                            .data![index].id
                                                            .toString(),
                                                        productName: snapshot
                                                            .data![index]
                                                            .productName,
                                                        initialPrice: snapshot
                                                            .data![index]
                                                            .initialPrice,
                                                        productPrice: newPrice,
                                                        quantity: quantity,
                                                        unitTag: snapshot
                                                            .data![index]
                                                            .unitTag
                                                            .toString(),
                                                        image: snapshot
                                                            .data![index].image
                                                            .toString(),
                                                      ))
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .initialPrice!
                                                                .toString()));
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print(error.toString());
                                                      });
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  snapshot.data![index].quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () {
                                                    int quantity = snapshot
                                                        .data![index].quantity!;
                                                    int initialPrice = snapshot
                                                        .data![index]
                                                        .initialPrice!;
                                                    quantity++;
                                                    int newPrice =
                                                        quantity * initialPrice;
                                                    dbHelper
                                                        .updateQuantity(Cart(
                                                      id: snapshot
                                                          .data![index].id,
                                                      productId: snapshot
                                                          .data![index].id
                                                          .toString(),
                                                      productName: snapshot
                                                          .data![index]
                                                          .productName,
                                                      initialPrice: snapshot
                                                          .data![index]
                                                          .initialPrice,
                                                      productPrice: newPrice,
                                                      quantity: quantity,
                                                      unitTag: snapshot
                                                          .data![index].unitTag
                                                          .toString(),
                                                      image: snapshot
                                                          .data![index].image
                                                          .toString(),
                                                    ))
                                                        .then((value) {
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.addTotalPrice(
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .initialPrice!
                                                              .toString()));
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print(error.toString());
                                                    });
                                                  },
                                                ),
                                              ],
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
                    ),
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Consumer<CartProvider>(
              builder: (context, value, child) {
                double subTotalPrice = value.getTotalPrice();
                double disCount = subTotalPrice * 0.05;
                double toTalPrice = subTotalPrice - disCount;
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                      ? false
                      : true,
                  child: Column(
                    children: [
                      ReusableWidget(
                          title: 'Subtotal',
                          value: r'$' + subTotalPrice.toStringAsFixed(2)),
                      ReusableWidget(
                          title: 'Discount',
                          value: r'$' + disCount.toStringAsFixed(2)),
                      ReusableWidget(
                          title: 'Total',
                          value: r'$' + toTalPrice.toStringAsFixed(2)),
                      Container(
                        height: 50,
                        width: 200,
                        child: Center(
                          child: Text(
                            "Pay Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
