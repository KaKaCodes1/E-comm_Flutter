// Importing the necessary Flutter material package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // Entry point of the application, runApp function starts the app
  runApp(
    ChangeNotifierProvider(
    create: (context) => CartModel(),
    child: const MyApp(),
    )
    );
}

// MyApp class which is the root of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides the structure for the app
    return MaterialApp(
      title: 'Shopeasy', // Title of the application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color theme
        scaffoldBackgroundColor: const Color(0xFFF5F5DC), // Background color
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const MyHomePage(), // Set the home page
    );
  }
}

// MyHomePage class representing the home page of the app
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController(); // Controller for search input

  // List of categories with names and image URLs
  List<Map<String, String>> categories = [
    {'name': 'Electronics', 'image': 'https://tinyurl.com/5d5bwe8a'},
    {'name': 'Clothing', 'image': 'https://images.unsplash.com/photo-1540221652346-e5dd6b50f3e7?q=80&w=1769&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
    {'name': 'Shoes', 'image': 'https://tinyurl.com/3b5reu78'},
    {'name': 'Books', 'image': 'https://tinyurl.com/56ketjmw'},
    {'name': 'Home & Kitchen', 'image': 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
    {'name': 'Toys', 'image': 'https://tinyurl.com/mbdc4nt9'},
  ];

  List<Map<String, String>> displayedCategories = []; // List of categories to display

  @override
  void initState() {
    super.initState();
    displayedCategories = List.from(categories); // Initialize displayed categories
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopeasy'), // Title of the app bar
        actions: <Widget>[
          // Search bar
          Container(
            width: 200,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search Categories...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onChanged: _filterCategories, // Filter categories as the user types
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person), // Profile icon
            onPressed: () {
              // Navigate to profile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart), // Cart icon
            onPressed: () {
              // Navigate to cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      // GridView to display categories
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: displayedCategories.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the category tiles
          return GestureDetector(
            onTap: () {
              // Navigate to category screen with the selected category
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CategoriesScreen(category: displayedCategories[index]['name']!),
              //   ),
              // );
              _navigateToCategory(context, displayedCategories[index]['name']!);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Column(
                children: [
                  Expanded(
                    // Display category image
                    child: Image.network(
                      displayedCategories[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Padding around the text
                    child: Text(
                      displayedCategories[index]['name']!, // Display category name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //function to control which products will be displayed
  void _navigateToCategory(BuildContext context, String categoryName){
    late Widget screen;
    switch(categoryName){
      case 'Electronics':
        screen = const ElectronicScreen(category: 'Electronics',);
        break;
      case 'Clothing':
        screen = const ClothScreen(category: 'Clothing',);
        break;
      case 'Shoes':
        screen = const ShoesScreen(category: 'Shoes',);
        break;
      case 'Books':
        screen = const BookScreen(category: 'Books',);
        break;
      case 'Home & Kitchen':
        screen = const HomeKitScreen(category: 'Home & Kitchen',);
        break;
      case 'Toys':
        screen = const ToysScreen(category: 'Toys',);
        break;
      default:
        const Text("Some error has occured!");
        break;
    }
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Function to filter categories based on search input
  void _filterCategories(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedCategories = List.from(categories);
      });
      return;
    }
    final filtered = categories.where((category) {
      final categoryName = category['name']!.toLowerCase();
      final searchLower = query.toLowerCase();
      return categoryName.contains(searchLower);
    }).toList();

    setState(() {
      displayedCategories = filtered;
    });
  }
}

// Screen to display the products of a specific category
class ElectronicScreen extends StatelessWidget {
  final String category;

  const ElectronicScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'Tablet', 'price': '\$100', 'stock': 'In Stock', 'image': 'https://tinyurl.com/4hvyf4wm', },
      {'name': 'Laptop', 'price': '\$150', 'stock': 'In Stock', 'image': 'https://tinyurl.com/3pbea7hr'},
      {'name': 'Mouse', 'price': '\$200', 'stock': 'In Stock', 'image': 'https://tinyurl.com/mvv4yrfr'},
      {'name': 'Keyboard', 'price': '\$300', 'stock': 'In Stock', 'image': 'https://tinyurl.com/2xdyh47h'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}// end of class




// Screen to display the products of a specific category
class ClothScreen extends StatelessWidget {
  final String category;

  const ClothScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'Hoodies', 'price': '\$100', 'stock': 'In Stock', 'image': 'https://images.pexels.com/photos/702350/pexels-photo-702350.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', },
      {'name': 'Official Coat', 'price': '\$150', 'stock': 'In Stock', 'image': 'https://images.pexels.com/photos/840916/pexels-photo-840916.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Tshirts', 'price': '\$200', 'stock': 'In Stock', 'image': 'https://images.pexels.com/photos/2294342/pexels-photo-2294342.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Scarfs', 'price': '\$250', 'stock': 'In Stock', 'image': 'https://images.pexels.com/photos/375880/pexels-photo-375880.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                     Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}//end of class



// Screen to display the products of a specific category
class BookScreen extends StatelessWidget {
  final String category;

  const BookScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'Secret Sevens', 'price': '\$100', 'stock': 'In Stock', 'image': 'https://th.bing.com/th/id/OIP.MCJvDWSRLQWufllK6eaWmAHaHa?rs=1&pid=ImgDetMain', },
      {'name': 'Dork Diaries', 'price': '\$150', 'stock': 'In Stock', 'image': 'https://cdn.shopify.com/s/files/1/0252/3362/1082/products/dork-diaries-rachel-renee-russell-collection-12-books-set-puppy-love-drama-queepaperbacksimon-schusterlowplex-25587317_800x.jpg?v=1583015126'},
      {'name': 'Diary of a Wimpy Kid', 'price': '\$200', 'stock': 'In Stock', 'image': 'https://n4.sdlcdn.com/imgs/j/f/3/Diary-Of-A-Wimpy-Kid-SDL477999179-1-c1944.jpg'},
      {'name': 'Goosebumps', 'price': '\$250', 'stock': 'In Stock', 'image': 'https://cdn.shopify.com/s/files/1/0338/4872/1545/products/IMG_1046_1400x1400.jpg?v=1603948768'},

    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                                        Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}//end of class




// Screen to display the products of a specific category
class ShoesScreen extends StatelessWidget {
  final String category;

  const ShoesScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'High Heels', 'price': '\$1000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/ymcn8wx7', },
      {'name': 'Sport Shoes', 'price': '\$1500', 'stock': 'In Stock', 'image': 'https://images.pexels.com/photos/2385477/pexels-photo-2385477.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Nike Low Dunks', 'price': '\$2000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/nhabfw4f'},
      {'name': 'Boots', 'price': '\$250', 'stock': 'In Stock', 'image': 'https://tinyurl.com/4t298pms'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                                        Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}//end of a class



// Screen to display the products of a specific category
class HomeKitScreen extends StatelessWidget {
  final String category;

  const HomeKitScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'Sofa', 'price': '\$1000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/bd2e259x', },
      {'name': 'Dinning set', 'price': '\$15000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/hw42dc74'},
      {'name': 'refrigerator', 'price': '\$2000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/h9d77rcv'},
      {'name': 'Chandelier', 'price': '\$3000', 'stock': 'In Stock', 'image': 'https://tinyurl.com/ycyt8t85'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}//end of a class



// Screen to display the products of a specific category
class ToysScreen extends StatelessWidget {
  final String category;

  const ToysScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of products with details
    List<Map<String, String>> products = [
      {'name': 'Baby Doll', 'price': '\$150', 'stock': 'In Stock', 'image': 'https://tinyurl.com/4s55jjdj'},
      {'name': 'Teddy Bear', 'price': '\$200', 'stock': 'In Stock', 'image': 'https://tinyurl.com/vzdvbrdx'},
      {'name': 'Toy Car', 'price': '\$250', 'stock': 'In Stock', 'image': 'https://tinyurl.com/3e9ev89f'},
      {'name': 'Toy piano', 'price': '\$300', 'stock': 'In Stock', 'image': 'https://tinyurl.com/59rfd8r6'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(category), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      // GridView to display products
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding for the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 1.0, // Aspect ratio of each tile (width / height)
        ),
        itemCount: products.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          // GestureDetector to handle taps on the product tiles
          return GestureDetector(
            onTap: () {
              // Add the product to the cart
              addToCart(context, products[index]);
            },
            child: Card(
              elevation: 3.0, // Elevation of the card
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  children: [
                    Text(
                      products[index]['name']!, // Display product name
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                    // Display category image
                    child: Image.network(
                      products[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                    Text(
                      products[index]['price']!, // Display product price
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      products[index]['stock']!, // Display product stock status
                      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}//end of a class


  // Function to add the product to the cart
  void addToCart(BuildContext context, Map<String, String> product) {
    // Implement logic to add the product to the cart
     final cart = Provider.of<CartModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Added to Cart'), // Alert dialog title
          content: Text('${product['name']} has been added to your cart.'), // Alert dialog content
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'), // OK button
            ),
            TextButton(
              onPressed: () {
              cart.addItem(CartItem(name: product['name']!, price: product['price']!));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product['name']} added to cart')),
            );
              },
             child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }


// Dummy ProfileScreen class to represent the user profile
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      body: const Center(
        child: Text('User Profile Screen'), // Text content of the profile screen
      ),
    );
  }
}

// Dummy CartScreen class to represent the shopping cart
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'), // Title of the app bar
        centerTitle: true, // Center the title
      ),
            body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Row(
                      children: [
                        
                        ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.price),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              cart.removeItem(item);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
                  ),
                  ElevatedButton(onPressed: (){
                    cart.clearCart();
                  },
                   child: const Text("Clear Cart"),
                   ),

                  //adding space between the buttons
                   const SizedBox(height: 5,),

                ElevatedButton(
                  onPressed: () {
                     // Add your checkout logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceeding to checkout')),
                      );
                  }, 
                  child: const Text('Checkout'))
            ],
          );
        }
      ),
    );
  }
}



class CartItem{
  final String name;
  final String price;

  CartItem({required this.name, required this.price});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

   void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

   void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(0.0, (total, current) => total + double.parse(current.price.substring(1)));
}
