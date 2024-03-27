import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final double price;
  final String description;
  final String seller_contact;
  final List<String> product_image;

  ProductDetailPage({
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.seller_contact,
    required this.product_image,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: TextStyle(
            color: Color(0xffA33DBA), // Text color
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xffA33DBA),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product_image.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    String i = widget.product_image[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          // i = widget.product_image[index],
                          'https://noteswapxyz.000webhostapp.com/admin/product_picture/$i',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Page indicator
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product_image.length,
                (index) => buildIndicator(index),
              ),
            ),
            // Name and Price Card
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.category,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₹${widget.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffA33DBA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Description Card
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 65),
          ],
        ),
      ),
      // Floating buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () {
                _makePhoneCall(widget.seller_contact);
              },
              child: Icon(Icons.call),
              backgroundColor: Color(0xffA33DBA),
            ),
            FloatingActionButton(
              onPressed: () {
                // Implement your action when the user taps the chat button
              },
              child: Icon(Icons.chat),
              backgroundColor: Color(0xffA33DBA),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage ? Color(0xffA33DBA) : Colors.grey,
      ),
    );
  }
}
