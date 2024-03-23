import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class PlatformUtils {
  static Future<void> shareToWhatsApp(String phoneNumber, String text) async {
    await launchUrl(Uri.https('wa.me', phoneNumber, {'text': text}));
  }

  static Future<void> copyToClipboard({
    required BuildContext context,
    required String text,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(
      text: text,
    ));
    messenger.showSnackBar(const SnackBar(
      content: Text('Copied to clipboard!'),
    ));
  }
}
