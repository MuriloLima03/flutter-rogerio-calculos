import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Importa o FFI do sqflite
import 'package:flutter/foundation.dart'; // Importa para verificar o ambiente
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Importa a versão da Web
import 'package:path/path.dart'; // Importa path para ajudar com o caminho do arquivo
import 'package:teste_app/models/product.dart'; // Importa a biblioteca sqflite para a versão nativa

class DBHelper {
  static Database? _database;

  // Método de inicialização da fábrica de banco de dados
  static Future<void> init() async {
    if (kIsWeb) {
      // Para Web, usa a versão específica para Web
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // Para plataformas nativas (Android/iOS), usa a versão FFI nativa
      databaseFactory = databaseFactoryFfi;
    }
  }

  // Método para obter a instância do banco de dados
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;  // Retorna se o banco de dados já estiver inicializado
    await init();  // Chama o método de inicialização
    _database = await _initDB('products.db');  // Cria o banco de dados se ainda não existir
    return _database!;
  }

  // Método para criar o banco de dados
  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();  // Obtém o caminho para o banco de dados
    final path = join(dbPath, filePath);  // Cria o caminho completo para o banco

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(''' 
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL
          )
        ''');  // Cria a tabela de produtos
      },
    );
  }

  // Método para inserir produtos no banco
  static Future<void> insertProduct(Product product) async {
    final db = await getDatabase();  // Obtém a instância do banco de dados
    await db.insert(
      'products',  // Nome da tabela
      product.toMap(),  // Converte o produto para mapa
      conflictAlgorithm: ConflictAlgorithm.replace,  // Substitui em caso de conflito
    );
  }

  // Método para obter todos os produtos do banco
  static Future<List<Product>> getProducts() async {
    final db = await getDatabase();  // Obtém a instância do banco de dados
    final List<Map<String, dynamic>> maps = await db.query('products');  // Consulta todos os produtos

    return List.generate(
      maps.length,
      (i) => Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
      ),
    );  // Converte os dados para uma lista de objetos Product
  }
}
