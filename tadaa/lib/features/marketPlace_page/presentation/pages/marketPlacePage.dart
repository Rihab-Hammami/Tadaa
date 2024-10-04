import 'package:flutter/material.dart';
import 'package:tadaa/features/marketPlace_page/presentation/pages/cartDetailsPage.dart';
import 'package:tadaa/features/marketPlace_page/presentation/widgets/buildCoverImage.dart';
import 'package:tadaa/features/marketPlace_page/presentation/widgets/productCardWidget.dart';


class MarketPlacePage extends StatefulWidget {
  const MarketPlacePage({Key? key,}) : super(key: key);

  @override
  State<MarketPlacePage> createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> CartDetailsPage())
                );             
            },
          ),
          // Search bar
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(       
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildImageContainer(),
              SizedBox(height:17),
              ProductCardWidget(),
            ],
          ),
        ),
      ),  
    );
  }
}
