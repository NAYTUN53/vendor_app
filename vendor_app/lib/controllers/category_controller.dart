import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/category.dart';

class CategoryController {
  // Load the uploaded categories
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(Uri.parse("$uri/api/categories"),
          headers: {"Content-Type": "application/json; charset=UTF-8"});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        throw Exception("Failed to load categories.");
      }
    } catch (e) {
      throw Exception("Error loading categories:  $e");
    }
  }
}
