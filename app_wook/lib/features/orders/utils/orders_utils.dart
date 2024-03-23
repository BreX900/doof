import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';

abstract class OrdersUtils {
  static String generateMessage(IList<ProductItem> items) {
    return _OrderMessage._from((b) => b.writeItems(items));
  }
}

class _OrderMessage {
  final _productsTexts = <String, int>{};

  _OrderMessage._();

  static String _from(void Function(_OrderMessage b) updates) {
    const header = 'Ciao volevo fare un ordine per domani alle 13.10 nome Kuama.\n';
    const conclusion = 'Grazie mille :-)';

    final builder = _OrderMessage._();
    updates(builder);

    final buffer = StringBuffer();
    builder._productsTexts.forEach((text, quantity) {
      if (buffer.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln();
      }

      buffer.write('-${quantity}x $text');
    });

    return '$header\n$buffer\n\n$conclusion';
  }

  void writeItems(IList<ProductItem> items) {
    for (final item in items) {
      assert(item.ingredientsRemoved.isEmpty);
      writeProduct(
        quantity: item.quantity,
        title: item.product.title,
        levels: item.levels,
        addableIngredients: item.ingredientsAdded,
      );
    }
  }

  void writeProduct({
    required int quantity,
    required String title,
    required IList<IngredientDto> addableIngredients,
    required IMap<LevelDto, double> levels,
  }) {
    final buffer = StringBuffer(title);

    // Ingredients
    buffer.writeAll(addableIngredients.map((e) => e.title).map((e) => ', $e'));

    // Levels
    buffer.writeAll(levels.entries.mapTo((ingredient, value) {
      return '${ingredient.title} ${ingredient.calculateByOffset(value)}';
    }).map((e) => ', $e'));

    final text = '$buffer';
    final prevQuantity = _productsTexts[text] ?? 0;
    _productsTexts[text] = prevQuantity + quantity;
  }
}
