// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';
import 'package:provider/provider.dart';

import '../Providers/visibility_provider.dart';

class DropDownUpdateOrderStatus extends StatefulWidget {
  DropDownUpdateOrderStatus({super.key, required this.userOrder});
  late List<String> list;
  final UserOrder userOrder;

  @override
  State<DropDownUpdateOrderStatus> createState() =>
      _DropDownUpdateOrderStatusState();
}

class _DropDownUpdateOrderStatusState extends State<DropDownUpdateOrderStatus> {
  String? dropdownValue;
  bool isLoading = false;
  late OrderCategoryVisibilityProvider orderCategoryVisibilityProvider;

  @override
  Widget build(BuildContext context) {
    orderCategoryVisibilityProvider = Provider.of(context);
    OrderProvider orderProvider = Provider.of(context);
    if (widget.userOrder.orderStatus == "Pending") {
      widget.list = <String>[
        'In Progress',
        'On The Way',
        'Completed',
        'Cancelled'
      ];
    } else if (widget.userOrder.orderStatus == "In Progress") {
      widget.list = <String>['On The Way', 'Completed', 'Cancelled'];
    } else {
      widget.list = ['Completed', 'Cancelled'];
    }
    dropdownValue = dropdownValue ?? widget.list.first;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Choose option given below to update order status"),
          DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextButton(
            onPressed: () {
              isLoading = true;
              _showConfirmationDialog(context, orderProvider,
                  widget.userOrder.orderId, dropdownValue!);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                )
              ]),
              child: isLoading
                  ? const LinearProgressIndicator()
                  : const Text(
                      "Update Order Status",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context,
      OrderProvider orderProvider, String orderId, String statusValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                // Action when "Yes" is pressed
                Navigator.of(context)
                    .pop(true); // Return true to handle "Yes" action
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Action when "Cancel" is pressed
                Navigator.of(context)
                    .pop(false); // Return false to handle "Cancel" action
                orderCategoryVisibilityProvider.updateVisibility();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((value) {
      // This will be executed after the dialog is dismissed.
      // value will be true if "Yes" was pressed, and false if "Cancel" was pressed or if the dialog was dismissed without selecting an option.
      if (value == true) {
        orderProvider
            .updateOrder(orderId: orderId, orderStatus: statusValue)
            .then((value) {
          if (value) {
            showSnackBar(
                context: context, content: 'Oder Updated Successfully :)');

            setState(() {
              isLoading = false;
            });

            Navigator.of(context).pop();
            orderCategoryVisibilityProvider.updateVisibility();
          } else {
            showSnackBar(context: context, content: 'Oder Updation Failed');

            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        showSnackBar(context: context, content: "Operation Cancelled");
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
