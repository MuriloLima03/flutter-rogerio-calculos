import 'package:flutter/material.dart';
import './screens/login.dart';
import './screens/import.dart';
import './screens/select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/import': (context) => const ImportScreen(),
        '/select': (context) => const SelectProductScreen(),
      },
    );
  }
}
