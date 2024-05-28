import 'package:flutter/material.dart';
import 'package:tadaa/Data/products.dart';
import 'package:tadaa/features/marketPlace_page/presentation/pages/detailsPage.dart';
import 'package:tadaa/models/product.dart';

class ProductCardWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 10.0,
        mainAxisExtent: 280,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) {
        return GestureDetector(
           onTap: () {
            navigateToDetailsPage(context, products[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: Image.network(
                        "${products.elementAt(index).image}",
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${products.elementAt(index).title}",
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "${products.elementAt(index).price}",
                                style: Theme.of(context).textTheme.subtitle2!.merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                              ),
                              Spacer(),
                              Icon(Icons.favorite),
                            ],
                          ),                       
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
void navigateToDetailsPage(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(product: product),
      ),
    );
  }
