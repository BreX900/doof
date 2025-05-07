import 'dart:io';

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main() async {
  final token = Platform.environment['TOKEN']!;
  final telegram = Telegram(token);
  final me = await telegram.getMe();

  final teleDart = TeleDart(token, Event(me.username!));

  teleDart.onMessage().listen((event) {
    telegram.sendMessage(event.chat.id, 'Ciao!');
    if (event.from!.id == 391802282) {
      //
    } else {
      //
    }
    print(event.toJson());
  });

  teleDart.start();
}
