import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // Set the list of orders
  void setOrders(List<Order> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    // update the state of the provider with the new list of orders
    state = [
      // loop through the existing orders
      for (final order in state)
        // check if the current order's id matches the id we want to update
        if (order.id == orderId)
          // create new order object with the updated order status
          Order(
              id: order.id,
              fullName: order.fullName,
              email: order.email,
              state: order.state,
              city: order.city,
              locality: order.locality,
              productName: order.productName,
              productPrice: order.productPrice,
              quantity: order.quantity,
              category: order.category,
              image: order.image,
              buyerId: order.buyerId,
              vendorId: order.vendorId,
              // use the new processing status if provided, otherwise keep the current status
              processing: processing ?? order.processing,
              delivered: delivered ?? order.delivered)

        // if the current id does not match, keep the order unchange
        else
          order
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>(
  (ref) {
    return OrderProvider();
  },
);
