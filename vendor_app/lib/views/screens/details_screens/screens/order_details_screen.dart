import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_app/controllers/order_controller.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/provider/order_provider.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final Order order;
  OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    // watch the list of orders to trigger while UI rebuilds
    final orders = ref.watch(orderProvider);
    // find the updated order status in the list
    final updatedOrders = orders.firstWhere((o) => o.id == widget.order.id,
        orElse: () => widget.order);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.order.productName,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
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
                              color: const Color.fromARGB(99, 239, 240, 242)),
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFBCC5FF)),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 5,
                                      child: Image.network(
                                        widget.order.image,
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
                                              MainAxisAlignment.spaceBetween,
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
                                                      width: double.infinity,
                                                      child: Text(
                                                        widget
                                                            .order.productName,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        widget.order.category,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: const Color(
                                                              0xFF7F808C),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${widget.order.productPrice.toString()} Ks",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: const Color(
                                                            0xFF0B0C1E),
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                            color: updatedOrders.delivered ==
                                                    true
                                                ? const Color(0xFF3C55EF)
                                                : updatedOrders.processing ==
                                                        true
                                                    ? Colors.purple
                                                    : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 9,
                                              top: 3,
                                              child: Text(
                                                updatedOrders.delivered == true
                                                    ? "Devlivered"
                                                    : updatedOrders
                                                                .processing ==
                                                            true
                                                        ? 'Processing'
                                                        : 'Cancelled',
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
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
                            Positioned(
                              left: 280,
                              top: 50,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(CupertinoIcons.delete),
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                width: 336,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFEFF0F2),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${widget.order.state}, ${widget.order.city}, ${widget.order.locality}',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'To: ${widget.order.fullName}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Order id: ${widget.order.id}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: updatedOrders.delivered == true ||
                                  updatedOrders.processing == false
                              ? null
                              : () async {
                                  await orderController
                                      .updateDeliveryStatus(
                                          id: widget.order.id, context: context)
                                      .whenComplete(() {
                                    ref
                                        .read(orderProvider.notifier)
                                        .updateOrderStatus(widget.order.id,
                                            delivered: true);
                                  });
                                },
                          child: Text(
                            updatedOrders.delivered == true
                                ? 'Delivered'
                                : 'Mark as Delivered?',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: updatedOrders.processing == false ||
                                  updatedOrders.delivered == true
                              ? null
                              : () async {
                                  await orderController
                                      .cancelOrder(
                                          id: widget.order.id, context: context)
                                      .whenComplete(() {
                                    ref
                                        .read(orderProvider.notifier)
                                        .updateOrderStatus(widget.order.id,
                                            processing: false);
                                  });
                                },
                          child: Text(
                            updatedOrders.processing == false
                                ? 'Cancelled'
                                : 'Cancel',
                            style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
