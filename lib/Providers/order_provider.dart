// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  List<UserOrder> pendingOrders = [];
  List<UserOrder> inProgressOrders = [];
  List<UserOrder> onWayOrders = [];
  List<UserOrder> completedOrders = [];
  List<UserOrder> cancelledOrders = [];

  OrderProvider() {
    loadOrders();
  }

  // Sorting comparator based on the timestamp field
  int _orderByTimestamp(UserOrder a, UserOrder b) {
    return b.timestamp.compareTo(a.timestamp);
  }

  Future<void> loadOrders() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      pendingOrders.clear();
      inProgressOrders.clear();
      onWayOrders.clear();
      completedOrders.clear();
      cancelledOrders.clear();

      for (final doc in snapshot.docs) {
        if (doc.data().containsKey('orderId')) {
          final order = UserOrder.fromMap(doc.data());

          if (order.orderStatus == 'Pending') {
            pendingOrders.add(order);
          } else if (order.orderStatus == 'In Progress') {
            inProgressOrders.add(order);
          } else if (order.orderStatus == 'On The Way') {
            onWayOrders.add(order);
          } else if (order.orderStatus == 'Completed') {
            completedOrders.add(order);
          } else if (order.orderStatus == 'Cancelled') {
            cancelledOrders.add(order);
          }
        }
      }

      // Sort the lists based on timestamp
      pendingOrders.sort(_orderByTimestamp);
      inProgressOrders.sort(_orderByTimestamp);
      onWayOrders.sort(_orderByTimestamp);
      completedOrders.sort(_orderByTimestamp);
      cancelledOrders.sort(_orderByTimestamp);

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error loading orders: $error');
    }
  }

  Future<bool> updateOrder(
      {required String orderId, required String orderStatus}) async {
    bool result = await updateOrderStatus(orderId, orderStatus);
    if (result) {
      loadOrders();
    }
    return result;
  }

  Future<List<UserOrder>> fetchOrdersByDays(int days) async {
    try {
      // Calculate the date 'days' days ago from the current date
      DateTime currentDate = DateTime.now();
      DateTime startDate = currentDate.subtract(Duration(days: days));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('timeStamp', isGreaterThanOrEqualTo: startDate)
          .where('orderStatus', isEqualTo: "Completed")
          .get();

      List<UserOrder> orders = querySnapshot.docs.map((doc) {
        return UserOrder.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      print("length of report items $orders");
      return orders;
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching orders: $error");
      }
      return [];
    }
  }
}

class UserOrder {
  final String userName;
  final String phone;
  final String location;
  final List<OrderItem> orderItems;
  final double extraPrice;
  final String orderStatus;
  final String userId;
  final double totalPrice;
  final Timestamp timestamp;
  final String orderId;
  UserOrder({
    required this.userName,
    required this.phone,
    required this.location,
    required this.orderItems,
    required this.extraPrice,
    required this.totalPrice,
    required this.orderStatus,
    required this.userId,
    required this.timestamp,
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userName': userName,
      'phone': phone,
      'location': location,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
      'extraPrice': extraPrice,
      'orderStatus': orderStatus,
      'userId': userId,
      'totalPrice': totalPrice,
      'timeStamp': timestamp,
    };
  }

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      orderId: map['orderId'],
      userName: map['userName'],
      phone: map['phone'],
      userId: map['userId'],
      location: map['location'],
      orderItems: List<OrderItem>.from(
          map['orderItems'].map((item) => OrderItem.fromMap(item))),
      extraPrice: map['extraPrice'],
      totalPrice: map['totalPrice'],
      orderStatus: map['orderStatus'],
      timestamp: map['timeStamp'],
    );
  }
}

class OrderItem {
  String item;
  int quantity;
  double perItemPrice;
  double totalPrice;

  OrderItem({
    required this.item,
    required this.quantity,
    required this.perItemPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'quantity': quantity,
      'perItemPrice': perItemPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      item: map['item'],
      quantity: map['quantity'],
      perItemPrice: map['perItemPrice'],
      totalPrice: map['totalPrice'],
    );
  }
}

//method to update the order-status of order
Future<bool> updateOrderStatus(String orderId, String orderStatus) async {
  try {
    // Get a reference to the "orders" collection in Firestore
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    // Query for the document with the given orderId
    QuerySnapshot querySnapshot =
        await ordersCollection.where('orderId', isEqualTo: orderId).get();

    // Check if a document with the given orderId exists
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming orderId is unique, there should be only one document in the result
      DocumentReference orderRef = querySnapshot.docs.first.reference;
      try {
        await orderRef.update({'orderStatus': orderStatus});
        return true;
      } catch (error) {
        print('Order with while updating: $error');
        return false;
      }
      // Now you have the order object with the specified orderId
    } else {
      print('Order with orderId $orderId not found.');
      return false;
    }
  } catch (error) {
    print('Error fetching in order update process: $error');
    return false;
  }
}
