import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required double productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("auth_token");
    if (pickedImages != null) {
      try {
        final cloudinary = CloudinaryPublic("dymyqeyyw", "t2mdxedr");
        List<String> images = [];

        for (int i = 0; i < pickedImages.length; i++) {
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
              CloudinaryFile.fromFile(pickedImages[i].path,
                  folder: productName));
          images.add(cloudinaryResponse.secureUrl);
        }

        if (category.isNotEmpty && subCategory.isNotEmpty) {
          final Product product = Product(
              id: '',
              productName: productName,
              productPrice: productPrice,
              quantity: quantity,
              description: description,
              category: category,
              vendorId: vendorId,
              fullName: fullName,
              subCategory: subCategory,
              images: images);
          http.Response response = await http.post(
              Uri.parse('$uri/api/add-product'),
              body: product.toJson(),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
                "x-auth-token": token!,
              });

          manageHttpResponse(
              response: response,
              context: context,
              onSuccess: () {
                showSnackBar(context, "Product uploaded");
              });
        }
      } catch (e) {
        debugPrint('Failed to upload images to cloudinary. Error: $e');
      }
    } else {
      showSnackBar(context, "Image unselected");
    }
  }
}
