import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const InfoView(
        title: Text('🫑 Non ci sono prodotti... 🫑\n🍽 Beh, cambia categoria! 🍽'),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final imageUrl = product.imageUrl;

        return ListTile(
          onTap: () => ProductRoute(product.id).go(context),
          leading: imageUrl != null ? CachedImage(imageUrl) : null,
          title: Text('${AppFormats.of(context).formatPrice(product.price)} - ${product.title}'),
          subtitle: Text(product.description),
        );
      },
    );
  }
}
