import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../databases/db_helper.dart';
import '../models/product.dart';
import '../screens/select.dart'; // Adicione o import para a tela de seleção

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool isLoading = false;

  Future<void> importProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://demo4527643.mockable.io/zoro')); // Fake API
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        // Decodificar a resposta da API
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('JSON Response: $jsonResponse');
        }

        // Verificar se a chave 'products' existe
        if (!jsonResponse.containsKey('products')) {
          throw Exception('Chave "products" ausente no JSON');
        }

        // Acessar a lista de produtos no campo 'products'
        List<dynamic> data = jsonResponse['products'];
        if (kDebugMode) {
          print('Data: $data');
        }

        // Validar os dados antes de converter
        List<Product> products = data.map((item) {
          if (item['id'] == null || item['name'] == null || item['price'] == null) {
            throw Exception('Dados inválidos: $item');
          }

          return Product(
            id: item['id'],
            name: item['name'],
            price: double.parse(item['price'].toString()),
          );
        }).toList();

        // Log dos produtos convertidos
        for (var product in products) {
          if (kDebugMode) {
            print('Produto convertido: $product');
          }
        }

        // Armazenar os produtos no SQLite
        for (var product in products) {
          await DBHelper.insertProduct(product);
          if (kDebugMode) {
            print('Produto inserido no banco: $product');
          }
        }

        // Mostrar o Snackbar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produtos importados com sucesso!')),
        );

        // Navegar para a tela de seleção
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectProductScreen()), // Substitua "SelectionScreen" pelo nome da sua tela de seleção
        );
      } else {
        throw Exception('Erro ao buscar dados da API');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro durante a importação: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao importar os produtos')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar Dados')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: importProducts,
                child: const Text('Importar Produtos'),
              ),
      ),
    );
  }
}
