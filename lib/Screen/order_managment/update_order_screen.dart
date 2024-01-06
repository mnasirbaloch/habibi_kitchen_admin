// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';
import 'package:provider/provider.dart';

import '../../Providers/order_provider.dart';
import '../../Providers/visibility_provider.dart';
import '../../comm_widget/drop_down_widget.dart';
import '../../comm_widget/order_item.dart';

class UpdateOrderScreen extends StatelessWidget {
  const UpdateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderCategoryVisibilityProvider orderCategoryVisibilityProvider =
        Provider.of(context);
    final UserOrder userOrder =
        ModalRoute.of(context)!.settings.arguments as UserOrder;
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffffff),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Order Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            // color: Color(0xfff85d01),
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff212435),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            orderCategoryVisibilityProvider.updateVisibility();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                // color: const Color(0xffc24a01),
                // color: Colors.black.withOpacity(0.5),
                color: Colors.blue.withOpacity(0.5),
                margin: const EdgeInsets.all(0),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5, top: 10, right: 5, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Order Status",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Colors.white,
                          // color: Color(0xfff85d01),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Status",
                                style: getTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(userOrder.orderStatus,
                                style: getTextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text("Customer Name",
                                style: getTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userOrder.userName,
                              textAlign: TextAlign.left,
                              style: getTextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Customer Mobile",
                                style: getTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userOrder.phone,
                              style: getTextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Customer Location",
                                style: getTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(userOrder.location,
                                maxLines: 2,
                                style: const TextStyle(
                                    overflow: TextOverflow.fade,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: const Text("Order Date",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              formatDateandTime(userOrder),
                              maxLines: 2,
                              style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Card(
                // color: Color(0xffFE5F00),
                // color: Colors.black.withOpacity(0.5),
                color: Colors.blue.withOpacity(0.5),
                margin: const EdgeInsets.all(0),
                child: const Center(
                  child: Text(
                    "Items",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      color: Colors.white,
                      // color: Color(0xfff85d01),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Table(
              border: TableBorder.all(
                width: 1.0,
                color: Colors.black,
              ),
              children: const [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Quantity",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Item Price",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Total Price",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Flexible(
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userOrder.orderItems.length,
                      itemBuilder: (context, index) {
                        return Table(
                          border:
                              TableBorder.all(width: 1.0, color: Colors.black),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      userOrder.orderItems[index].item,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    userOrder.orderItems[index].quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    userOrder.orderItems[index].perItemPrice
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "${userOrder.orderItems[index].quantity * userOrder.orderItems[index].perItemPrice}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: Table(
                      border: TableBorder.all(width: 1.0, color: Colors.black),
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text(
                                "Total Price",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                getTotalBill(itemTotal: userOrder.totalPrice)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Flexible(
              child: InkWell(
                onTap: () async {
                  if (await orderProvider.updateOrder(
                      orderId: userOrder.orderId, orderStatus: 'In Progress')) {
                    showSnackBar(
                      context: context,
                      content: 'Order Updated Successfully',
                      textAlign: TextAlign.center,
                    );
                  } else {
                    showSnackBar(
                      context: context,
                      content: 'Order Updation Failed',
                      textAlign: TextAlign.center,
                    );
                  }
                },
                child: SizedBox(
                  child: DropDownUpdateOrderStatus(
                    userOrder: userOrder,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

double getTotalBill({required double itemTotal}) {
  return itemTotal == 0
      ? 0
      : itemTotal <= 500
          ? itemTotal + itemTotal * 0.02
          : itemTotal <= 1000
              ? (itemTotal + itemTotal * 0.02 + 50).toInt().toDouble()
              : (itemTotal + itemTotal * 0.02 + 50).toInt().toDouble();
}

String formatDateandTime(UserOrder order) {
  return ("${getDayName(order.timestamp.toDate().weekday)} ${order.timestamp.toDate().day} ${getMonthName(order.timestamp.toDate().month)} ${order.timestamp.toDate().year} at ${formatTime(order.timestamp.toDate().hour, order.timestamp.toDate().minute)}");
}
