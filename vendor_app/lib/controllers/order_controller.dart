import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class OrderController {
  // Get orders by vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      // Send an http request to get the orders by buyerId
      http.Response response = await http.get(
          Uri.parse("$uri/api/orders/vendors/$vendorId"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token!,
          });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Error found in loading orders");
      }
    } catch (e) {
      throw Exception('Failed to load orders');
    }
  }

  // Delete Order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      http.Response response = await http.delete(
          Uri.parse("$uri/api/orders/vendors/$id"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order was successfully deleted.");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // http patch method for marking the order as delivered
  Future<void> updateDeliveryStatus({required id, required context}) async {
    try {
      http.Response response = await http.patch(
          Uri.parse("$uri/api/orders/$id/delivered"),
          body: jsonEncode({"delivered": true, "processing": false}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order has been mark as delivered");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // http patch method for cancelling the order
  Future<void> cancelOrder({required id, required context}) async {
    try {
      http.Response response = await http.patch(
          Uri.parse("$uri/api/orders/$id/processing"),
          body: jsonEncode({"processing": false, "delivered": false}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order has been cancelled");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
