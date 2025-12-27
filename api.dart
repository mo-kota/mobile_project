import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch products: ${res.statusCode}');
    }
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProduct(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch product $id: ${res.statusCode}');
    }
    final Map<String, dynamic> data = jsonDecode(res.body);
    return Product.fromJson(data);
  }

  List<Product> filterProducts(List<Product> products, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }
}