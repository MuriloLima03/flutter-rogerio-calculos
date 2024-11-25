class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  // Converte um produto para um mapa para inserção no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Construtor para criar um produto a partir de um mapa
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price}';
  }
}
