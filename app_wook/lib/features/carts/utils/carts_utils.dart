import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:mek_gasol/apis/platform_utils.dart';

abstract class CartsUtils {
  static Future<void> share({required BuildContext context, required CartModel cart}) async {
    final url = Uri.base.replace(fragment: '');

    await PlatformUtils.copyToClipboard(
      context: context,
      text: '$url/carts/${cart.id}',
    );
  }
}
