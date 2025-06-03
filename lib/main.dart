import 'package:flutter/material.dart';
import 'core/services/injection_container.dart' as di;
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
