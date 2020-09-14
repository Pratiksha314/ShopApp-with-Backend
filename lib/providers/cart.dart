import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id, //it has a different id from the product id
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items={}; //initialize with empty map
   // syntax Map<key,value>
  //so here key is of products id which is String
  //value is of type CartItem

  Map<String, CartItem> get items {
    //getter
    return {..._items}; //to get the key,value
    // pairs from the above and return here the copy
  }
  int get itemCount{ 
    return _items.length;  // returns how many no. of items are there in cart
  }

  double get totalAmount{
    var total=0.0;
    _items.forEach((key,cartItem){
   total+=cartItem.price*cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // productId is (key)
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }
  void removeItem(String productId){
   _items.remove(productId);
   notifyListeners();
  }

  void removeSingleItem(String productId){
   if(!_items.containsKey(productId)){  //if the product is not the cart
     return; //return nothing
   }
   if(_items[productId].quantity>1){
        // to remove only 1 quantity of the product
     _items.update (productId,(existingCartItem)=>
     CartItem(id: existingCartItem.id,
      title: existingCartItem.title,
       quantity: existingCartItem.quantity - 1,
        price: existingCartItem.price),);
   }
   else{ //to remove the entire product
     _items.remove(productId);
   }
   notifyListeners();
  }
  void clearCart(){
  _items={};
  notifyListeners();
}

}
