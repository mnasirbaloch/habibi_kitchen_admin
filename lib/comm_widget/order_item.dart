import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/order_provider.dart';
import '../Providers/time_provider.dart';

class OrderItemView extends StatelessWidget {
  const OrderItemView({
    Key? key,
    required this.index,
    required this.order,
    required this.color,
    this.isButtonVisible,
    required this.onUpdatePressed,
    required this.orderItemList,
  }) : super(key: key);
  final int index;
  final UserOrder order;
  final Color color;
  final bool? isButtonVisible;
  final void Function() onUpdatePressed;
  final List<OrderItem> orderItemList;

  @override
  Widget build(BuildContext context) {
    // OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5.0),
        // border: Border.all(color: const Color(0xffFE5F00), width: 1),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 15, 14, 14),
              border: Border(
                right: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0, // You can adjust the width as needed
                ),
              ),
            ),
            child: Text(
              (index + 1).toString(),
              style: getTextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    concatenateItemNames(
                      orderItemList,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Builder(builder: (context) {
                    return Consumer<MyTimeProvider>(
                      builder: (context, value, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              order.orderStatus.toLowerCase() ==
                                      "Completed".toLowerCase()
                                  ? "Completed: "
                                  : "Order Placed:",
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  order.orderStatus == "Completed"
                                      ? formatDateandTime(order)
                                      : "${calculateTimeDifference(Timestamp.now(), order.timestamp)} Ago",
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isButtonVisible ?? true,
            child: TextButton(
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(4),
                backgroundColor: MaterialStatePropertyAll(
                  color,
                ),
              ),
              onPressed: onUpdatePressed,
              child: FittedBox(
                child: Text(
                  "Update",
                  maxLines: 1,
                  style: getTextStyle(
                    color: Colors.white,
                    // color: const Color(
                    //   0xffc24a01,
                    // ),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String concatenateItemNames(List<OrderItem> orderItems) {
  List<String> items = orderItems.map((order) => order.item).toList();
  return items.join(',');
}

String getDayName(int day) {
  // Ensure day is between 1 and 7 (Monday to Sunday)
  if (day < 1 || day > 7) {
    throw ArgumentError('Invalid day: $day. Day must be between 1 and 7.');
  }

  // List of day names starting from Monday (index 1) to Sunday (index 7)
  List<String> dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Return the day name
  return dayNames[day - 1];
}

String getMonthName(int month) {
  // Ensure month is between 1 and 12
  if (month < 1 || month > 12) {
    throw ArgumentError(
        'Invalid month: $month. Month must be between 1 and 12.');
  }

  // List of month names
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Return the month name
  return monthNames[month - 1];
}

String formatTime(int hour, int minute) {
  // Ensure the hour is between 0 and 23, and the minute is between 0 and 59
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    throw ArgumentError('Invalid hour or minute value.');
  }

  // Determine AM or PM
  String meridian = (hour >= 12) ? 'PM' : 'AM';

  // Convert the hour to 12-hour format if needed
  int hour12 = (hour > 12) ? hour - 12 : hour;

  // Format the time string
  String timeString =
      ' ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $meridian';

  return timeString;
}

String formatDateandTime(UserOrder order) {
  return ("${getDayName(order.timestamp.toDate().weekday)} ${order.timestamp.toDate().day} ${getMonthName(order.timestamp.toDate().month)} ${order.timestamp.toDate().year} at ${formatTime(order.timestamp.toDate().hour, order.timestamp.toDate().minute)}");
}

TextStyle getTextStyle({
  Color color = Colors.black,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

String calculateTimeDifference(
    Timestamp currentTimestamp, Timestamp oldTimestamp) {
  DateTime currentDateTime = currentTimestamp.toDate();
  DateTime oldDateTime = oldTimestamp.toDate();

  Duration difference = currentDateTime.difference(oldDateTime);

  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);

  String formattedDifference = ' $hours Hours $minutes Minutes';

  return formattedDifference;
}
