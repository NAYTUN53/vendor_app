import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_app/controllers/order_controller.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/provider/order_provider.dart';
import 'package:vendor_app/provider/vendor_provider.dart';
import '../details_screens/screens/order_details_screen.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // method to load the orders within the provider
  Future<void> _fetchOrders() async {
    final user = ref.read(vendorProvider);
    if (user != null) {
      final orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: user.id);

        // store the orders in provider
        ref.read(orderProvider.notifier).setOrders(orders);
      } catch (e) {
        throw Exception('Error fetching orders. $e');
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final OrderController orderController = OrderController();
    try {
      await orderController.deleteOrder(id: orderId, context: context);
      _fetchOrders();
    } catch (e) {
      throw Exception('Error in deleting order');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/icons/cartb.png",
            ),
            fit: BoxFit.cover,
          )),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/icons/not.png",
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.yellow.shade800),
                        child: Center(
                          child: Text(
                            orders.length.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  "My Orders",
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found.'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return OrderDetailsScreen(order: order);
                        }),
                      );
                    },
                    child: Container(
                      width: 335,
                      height: 153,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 336,
                                height: 154,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          99, 239, 240, 242)),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 13,
                                      top: 9,
                                      child: Container(
                                        width: 78,
                                        height: 78,
                                        clipBehavior: Clip.none,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFFBCC5FF)),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 10,
                                              top: 5,
                                              child: Image.network(
                                                order.image,
                                                width: 58,
                                                height: 67,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              left: 101,
                                              top: 14,
                                              child: SizedBox(
                                                width: 216,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                order
                                                                    .productName,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                order.category,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: const Color(
                                                                      0xFF7F808C),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "${order.productPrice.toString()} Ks",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                color: const Color(
                                                                    0xFF0B0C1E),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 5,
                                              top: 100,
                                              child: Container(
                                                width: 100,
                                                height: 25,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                    color: order.delivered ==
                                                            true
                                                        ? const Color(
                                                            0xFF3C55EF)
                                                        : order.processing ==
                                                                true
                                                            ? Colors.purple
                                                            : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Positioned(
                                                      left: 9,
                                                      top: 3,
                                                      child: Text(
                                                        order.delivered == true
                                                            ? "Devlivered"
                                                            : order.processing ==
                                                                    true
                                                                ? 'Processing'
                                                                : 'Cancelled',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    order.delivered == true ? Positioned(
                                      left: 280,
                                      top: 50,
                                      child: IconButton(
                                        onPressed: () {
                                          deleteOrder(order.id);
                                        },
                                        icon: const Icon(CupertinoIcons.delete),
                                        color: Colors.red,
                                      ),
                                    )
                                    : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
