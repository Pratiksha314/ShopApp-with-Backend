import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart.dart';
import '../widgets/products_grid.dart';

enum PopmenuValues {
  Favorites, //0
  All, //1
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName='/products-overview-screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit=true;
 var _isLoading=false;

 @override
 void didChangeDependencies() { //fetch data http.get wala
   if(_isInit){
     setState(() {
       _isLoading=true;
     });
  
     Provider.of<Products>(context).fetchAndSetProducts().then((_){
      setState(() {
       _isLoading=false;
     });
  
       
     });
   }
   _isInit=false;
   super.didChangeDependencies();
   
 }
  @override
  Widget build(BuildContext context) {
    //  final productsConatiner=Provider.of<Products>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (PopmenuValues selectedValue) {
              setState(() {
                if (selectedValue == PopmenuValues.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favourites!!'),
                value:
                    PopmenuValues.Favorites //which item is chosen by the user
                ,
              ),
              PopupMenuItem(
                child: Text('show all'),
                value: PopmenuValues.All //which item is chosen by the user
                ,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              //ch child hai..joki icon button hai
              // and it won't be changing again & again
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:_isLoading? Center(
        child: CircularProgressIndicator(),) :
       ProductsGrid(_showOnlyFavorites),
    );
  }
}
