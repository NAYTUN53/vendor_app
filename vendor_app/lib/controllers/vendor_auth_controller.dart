import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/provider/vendor_provider.dart';
import 'package:vendor_app/services/manage_http_response.dart';
import 'package:vendor_app/views/screens/main_vendor_screen.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor(
      {required String fullName,
      required String email,
      required String password,
      required context}) async {
    try {
      Vendor vendor = Vendor(
          id: '',
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          role: '',
          password: password);

      http.Response response = await http.post(
          Uri.parse("$uri/api/vendor/signup"),
          body: vendor.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Vendor account has been created");
          });
    } catch (e) {
      showSnackBar(context, "Failed to create vendor account");
    }
  }

  // Vendor sign in

  Future<void> signInVendor(
      {required String email,
      required String password,
      required context}) async {
    try {
      Vendor vendor = Vendor(
          id: '',
          fullName: '',
          email: email,
          state: '',
          city: '',
          locality: '',
          role: '',
          password: password);

      http.Response response = await http.post(
          Uri.parse("$uri/api/vendor/signin"),
          body:
              jsonEncode({'email': vendor.email, 'password': vendor.password}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String token = jsonDecode(response.body)['token'];
            await preferences.setString('auth_token', token);

            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);

            await preferences.setString('vendor', vendorJson);

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const MainVendorScreen();
            }), (route) => false);
            showSnackBar(context, "Vendor successfully Sign in");
          });
    } catch (e) {
      showSnackBar(context, "Error signing in to vendor account. Error: $e");
    }
  }
}
