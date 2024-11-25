import 'package:flutter/material.dart';
import '../databases/db_helper.dart';
import '../models/product.dart';

class SelectProductScreen extends StatefulWidget {
  const SelectProductScreen({super.key});

  @override
  _SelectProductScreenState createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  List<Product> products = [];
  Product? selectedProduct;
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await DBHelper.getProducts();
    setState(() {});
  }

  void calculateTotal() {
    final quantity = int.tryParse(quantityController.text);
    if (quantity != null && selectedProduct != null) {
      final total = selectedProduct!.price * quantity;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Total a Pagar'),
          content: Text('Produto: ${selectedProduct!.name}\n'
              'Quantidade: $quantity\n'
              'Valor Total: R\$${total.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  void placeOrder() {
    final quantity = int.tryParse(quantityController.text);
    if (quantity != null && selectedProduct != null) {
      final total = selectedProduct!.price * quantity;

      // Simula o envio do pedido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pedido realizado com sucesso!\n'
            'Produto: ${selectedProduct!.name}\n'
            'Quantidade: $quantity\n'
            'Total: R\$${total.toStringAsFixed(2)}',
          ),
        ),
      );
      // Aqui você pode adicionar lógica adicional, como salvar o pedido no banco ou enviar para um servidor
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleção de Produtos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Product>(
              hint: const Text('Selecione um produto'),
              value: selectedProduct,
              onChanged: (Product? value) {
                setState(() {
                  selectedProduct = value;
                });
              },
              items: products.map((product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedProduct != null)
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}), // Força a atualização ao digitar
              ),
            const SizedBox(height: 20),
            if (selectedProduct != null)
              ElevatedButton(
                onPressed: calculateTotal,
                child: const Text('Calcular'),
              ),
            const SizedBox(height: 20),
            if (selectedProduct != null)
              ElevatedButton(
                onPressed: placeOrder,
                child: const Text('Enviar Pedido'),
              ),
          ],
        ),
      ),
    );
  }
}
