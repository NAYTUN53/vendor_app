import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/order.dart';

class TotalEarningProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningProvider() : super({'totalEarnings': 0.0, 'totalOrders': 0});

  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;
    // calculate the total earning by looping through the list of orders
    for (final order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    // update the provider state with the calculated earnings.
    state = {
      "totalEarnings": earnings,
      "totalOrders": orderCount,
    };
  }
}

final totalEarningProvider =
    StateNotifierProvider<TotalEarningProvider, Map<String, dynamic>>((ref) {
  return TotalEarningProvider();
});
