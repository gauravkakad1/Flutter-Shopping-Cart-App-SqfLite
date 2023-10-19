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
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context,listen: true);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Product List"),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                },
                child: Center(
                  child: Badge.Badge(
                    badgeContent : Consumer<CartProvider>(
                      builder: (context, value, child) {
                        return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white),);
                      },),
                      badgeAnimation: Badge.BadgeAnimation.slide(animationDuration: Duration(seconds: 2)),
                      child: Icon(Icons.shopping_cart)
                  ),
                ),
              ),
              SizedBox(width: 20,)
            ]
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                  child: ListView.builder(
                    itemCount: productName.length,
                    itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          child: Card(
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height : 100,width: 100,
                                    child: ClipRect(child: Image.network(productImage[index]),)
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5,),
                                      Text(productName[index].toString() ,
                                        style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                                      SizedBox(height: 5,),
                                      Text(productUnit[index].toString()+r" $"+productPrice[index].toString() ,
                                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                      SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: (){
                                            dbHelper!.insert(Cart(
                                                id : index,
                                                productId : index.toString(),
                                                productName: productName[index].toString(),
                                                initialPrice: productPrice[index],
                                                productPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index].toString(),
                                                image: productImage[index].toString()
                                            )
                                            ).then((value) {
                                              cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cart.addCounter();
                                            }).onError((error, stackTrace) {
                                                  print(error.toString());
                                            });

                                          },
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(6)),
                                            child: Center(child: Text("Add to cart",style: TextStyle(color: Colors.white),)),

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,)

                              ],
                            ),
                          ),
                        );
                      },
                  )
              ),
            ],
          ),
        )
    );
  }
}
