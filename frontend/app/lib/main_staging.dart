import 'package:flutter/material.dart';
import 'package:print_ia_chat_bot/app/app.dart';
import 'package:print_ia_chat_bot/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(() => const App());
}
