import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName='/user-products-screen';
  
  Future<void> _refreshProducts(BuildContext context) async {

 await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);

}

  @override
  Widget build(BuildContext context) {
    // final productsData=Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title:const Text('Your Products'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add),
           onPressed: (){
             Navigator.of(context).pushNamed('/edit');
           }),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
              builder: (ctx,snapshot)=>
              snapshot.connectionState==ConnectionState.waiting ? 
              Center(child: CircularProgressIndicator(),) : 
              RefreshIndicator(
          onRefresh:()=>_refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx,productsData,_)=>
                                   Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount:productsData.items.length ,
              itemBuilder: (_,i)=>Column(
                  children: <Widget>[
                     UserProductItem(

                      productsData.items[i].id,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,

                  ),
                  Divider(),
                  ],           
              ),
              ),
          ),
                ),
        ),
      ),
    );
  }
}