import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int noOfDaysToGenerateReport = 1;
  List<UserOrder> userOrderList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          80,
        ),
        child: Container(
          color: Colors.blue,
          child: SafeArea(
            child: Column(
              children: [
                const Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getButton(
                      text: '1-Day',
                      onTap: () async {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        userOrderList =
                            await orderProvider.fetchOrdersByDays(1);
                        setState(() {
                          isLoading = !isLoading;
                          if (userOrderList.isEmpty) {
                            showMessage(context,
                                message: "No Item Purchased Last Day");
                          }
                        });
                      },
                    ),
                    getButton(
                      text: '3-Day',
                      onTap: () async {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        userOrderList =
                            await orderProvider.fetchOrdersByDays(3);
                        setState(
                          () {
                            isLoading = !isLoading;
                            if (userOrderList.isEmpty) {
                              showMessage(context,
                                  message: "No Item Purchased in Last 3 Days");
                            }
                          },
                        );
                      },
                    ),
                    getButton(
                      text: '7-Day',
                      onTap: () async {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        userOrderList =
                            await orderProvider.fetchOrdersByDays(7);
                        setState(
                          () {
                            isLoading = !isLoading;
                            if (userOrderList.isEmpty) {
                              showMessage(context,
                                  message: "No Item Purchased in Last 7 Days");
                            }
                          },
                        );
                      },
                    ),
                    getButton(
                      text: '30-Days',
                      onTap: () async {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        userOrderList =
                            await orderProvider.fetchOrdersByDays(30);
                        setState(
                          () {
                            isLoading = !isLoading;
                            if (userOrderList.isEmpty) {
                              showMessage(context,
                                  message: "No Item Purchased in Last Month");
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : userOrderList.isEmpty
                      ? const Center(
                          child: Text(
                            "Please select an option to generate report",
                          ),
                        )
                      : Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Table(
                                border: TableBorder.all(
                                  color: Colors.blue,
                                ),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(50),
                                  1: FlexColumnWidth(),
                                  2: FixedColumnWidth(75)
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child:
                                              Text('No', style: getTextStyle()),
                                        ),
                                      ),
                                      // TableCell(child: Text(e.orderId)),
                                      TableCell(
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              'Items',
                                              style: getTextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              'Order Price',
                                              style: getTextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.blue,
                                  ),
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: FixedColumnWidth(50),
                                    1: FlexColumnWidth(),
                                    2: FixedColumnWidth(75)
                                  },
                                  children: userOrderList.toTableRow(),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                margin: EdgeInsets.zero,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                color: Colors.blue,
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.transparent,
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Text(
                                            "Total Order Completed",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            userOrderList.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ).centerText(),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Text(
                                            "Total Income",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            userOrderList
                                                .getOrdersTotalPrice()
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ).centerText(),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Text(
                                            "Total Expenses",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            (userOrderList
                                                        .getOrdersTotalPrice() -
                                                    (userOrderList
                                                                .getOrdersTotalPrice() /
                                                            5)
                                                        .ceilToDouble())
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ).centerText(),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Text(
                                            "Total Profit",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            (userOrderList
                                                        .getOrdersTotalPrice() /
                                                    5)
                                                .ceilToDouble()
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ).centerText(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(message),
        ),
      ),
    );
  }
}

TextButton getButton({required String text, required Function() onTap}) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

extension on List<UserOrder> {
  List<TableRow> toTableRow() {
    return map(
      (e) => TableRow(
        children: [
          TableCell(
            child: Center(child: Text((indexOf(e) + 1).toString())),
          ),
          // TableCell(child: Text(e.orderId)),
          TableCell(
            child: Center(
              child: Text(
                getOrderItemListName(e),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          TableCell(
            child: Center(
              child: Text(
                e.totalPrice.toString(),
              ),
            ),
          ),
        ],
      ),
    ).toList();
  }

  double getOrdersTotalPrice() {
    return map((e) => e.totalPrice)
        .toList()
        .reduce((value, element) => value + element);
  }
}

String getOrderItemListName(UserOrder userOrder) {
  return userOrder.orderItems
      .map((e) => e.item)
      .toList()
      .reduce((value, element) => '$value, $element');
}

TextStyle getTextStyle() {
  return const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );
}

extension on Text {
  Container centerText() {
    return Container(
      padding: const EdgeInsets.only(
        right: 5,
      ),
      alignment: Alignment.centerRight,
      child: this,
    );
  }
}
