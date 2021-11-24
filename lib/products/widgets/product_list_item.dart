import 'package:flutter/material.dart';
import 'package:flutter_web_shopping/products/models/models.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> itemDetails = <Widget>[
      Image(image: NetworkImage(product.imageUrl), fit: BoxFit.scaleDown, height: 400,),
      Text(product.title),
      Text(product.description),
      Text('Category: ${product.category}'),
      Text('Rating: ${product.rating.rate.toString()}'),
      Text('\$${product.price.toStringAsFixed(2)}'),
    ];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.4,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: itemDetails.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: itemDetails[index],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              );
            }
        );
      },
      child: Card(
        child: Column(
          children: [
            Image(image: NetworkImage(product.imageUrl), fit: BoxFit.scaleDown, height: 150,),
            Text(product.title, overflow: TextOverflow.ellipsis,),
            Text('\$${product.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}