import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:noteswap/screens/product/product_details.dart';
import 'package:noteswap/screens/product/add_products.dart';
import 'package:noteswap/screens/chatbox/chat_home.dart';
import 'package:noteswap/screens/profile/user_profile_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String selectedCategory;
  late String searchQuery;

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> category = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = 'All';
    searchQuery = '';
    filterProducts();
    filterProductsByCategory(selectedCategory);
    fetchCategories();
    fetchProducts();
  }

  void filterProductsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredProducts = ProductData;
      } else {
        filteredProducts =
            ProductData.where((product) => product['category'] == category)
                .toList();
      }
    });
  }

  void filterProducts() {
    setState(() {
      if (selectedCategory == 'All') {
        filteredProducts = ProductData.where((product) => product['title']
            .toLowerCase()
            .contains(searchQuery.toLowerCase())).toList();
      } else {
        filteredProducts = ProductData.where((product) =>
            product['category'] == selectedCategory &&
            product['title']
                .toLowerCase()
                .contains(searchQuery.toLowerCase())).toList();
      }
    });
  }

  Future<void> fetchProducts() async {
    final url = 'https://noteswapxyz.000webhostapp.com/api/products.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      setState(() {
        // Replace the existing ProductData with the fetched data
        ProductData.clear();
        ProductData.addAll(List<Map<String, dynamic>>.from(productsJson));
      });
    } else {
      print('Failed to load products: ${response.statusCode}');
    }
  }

  Future<void> fetchCategories() async {
    final url = 'https://noteswapxyz.000webhostapp.com/api/category.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = jsonDecode(response.body);
      setState(() {
        category.clear();
        category.addAll(List<Map<String, dynamic>>.from(categoriesJson));
      });
    } else {
      // Handle errors
      print('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<void> _refreshData() async {
    // Fetch products and categories again to refresh data
    await fetchProducts();
    await fetchCategories();
  }

  final List<Map<String, dynamic>> ProductData = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print(filteredProducts);
        bool shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
        if (shouldExit == true) {
          exit(0);
        }
        return !shouldExit;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                    ),
                    Image.asset(
                      'assets/images/logo-wobg.png',
                      height: 60,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffA33DBA),
                        radius: 30,
                        child: IconButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person),
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                    right: 2,
                    top: 25.0,
                    bottom: 2.0,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        filterProducts();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return CategoryItem(
                          category_name: 'All',
                          isSelected: selectedCategory == 'All',
                          onTap: () => filterProductsByCategory('All'),
                        );
                      } else {
                        final categoryName =
                            category[index - 1]['category_name'];
                        return CategoryItem(
                          category_name: categoryName,
                          isSelected: selectedCategory == categoryName,
                          onTap: () => filterProductsByCategory(categoryName),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Wrap(
                        runSpacing: 8,
                        spacing: 12,
                        children: filteredProducts.map((productData) {
                          return carddesign(
                              productData['product_image'],
                              productData['title'],
                              productData['category'],
                              productData['price'],
                              productData['description'],
                              productData['seller_contact'],
                              context);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProduct(),
                    ),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              ),
              SizedBox(height: 12.0),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatUserList()),
                  );
                },
                child: Icon(Icons.chat),
                backgroundColor: Color(0xffA33DBA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String category_name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.category_name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffA33DBA) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            category_name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : null,
            ),
          ),
        ),
      ),
    );
  }
}

Widget carddesign(
    List<dynamic> product_image,
    String title,
    String category,
    String price,
    String description,
    String seller_contact,
    BuildContext context) {
  List<String> imageUrls = product_image.cast<String>();
  String firstImage = imageUrls.isNotEmpty ? imageUrls[0] : '';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            title: title,
            category: category,
            price: double.parse(price),
            description: description,
            product_image: imageUrls,
            seller_contact: seller_contact,
          ),
        ),
      );
    },
    child: Container(
      height: 320,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(23, 23)),
        color: Color.fromARGB(255, 243, 236, 245),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.elliptical(23, 23),
                topLeft: Radius.elliptical(23, 23),
              ),
              color: Color(0xffA33DBA),
              image: DecorationImage(
                image: NetworkImage(
                    'https://noteswapxyz.000webhostapp.com/admin/product_picture/$firstImage'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
            child: Text(
              '₹ $price',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffA33DBA),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
