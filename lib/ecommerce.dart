import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// Product model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

// Cart Item model with quantity
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// Cart Provider
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key = product id

  List<CartItem> get cartItems => _items.values.toList();

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity > 1) {
        _items[product.id]!.quantity--;
      } else {
        _items.remove(product.id);
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
  }
}

// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce App',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: HomePage(),
      ),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Sneakers',
      description: 'Cool sneakers to walk in style.',
      price: 59.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      name: 'Watch',
      description: 'Stylish wrist watch for any outfit.',
      price: 129.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '3',
      name: 'Backpack',
      description: 'Spacious and modern backpack.',
      price: 89.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) => ListTile(
          leading: Image.network(products[index].imageUrl, width: 50),
          title: Text(products[index].name),
          subtitle: Text("\$${products[index].price.toStringAsFixed(2)}"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: products[index]),
            ),
          ),
        ),
      ),
    );
  }
}

// Product Detail Page
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Image.network(product.imageUrl, height: 200),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(product.description),
          ),
          Text("\$${product.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              cartProvider.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${product.name} added to cart'),
              ));
            },
            child: Text("Add to Cart"),
          )
        ],
      ),
    );
  }
}

// Cart Page
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: cart.cartItems.isEmpty
          ? Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (_, i) {
                final item = cart.cartItems[i];
                return ListTile(
                  leading: Image.network(item.product.imageUrl, width: 50),
                  title: Text(item.product.name),
                  subtitle: Text(
                      "Price: \$${item.product.price.toStringAsFixed(2)}\nQty: ${item.quantity}"),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => cart.removeFromCart(item.product),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Text("Total: \$${cart.totalPrice.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
