import 'package:flutter/material.dart';
import 'order_provider.dart'; // Import your OrderProvider class

enum OrderType {
  pending,
  inProgress,
  onTheWay,
  completed,
  cancelled,
}

class OrderCategoryVisibilityProvider extends ChangeNotifier {
  final OrderProvider orderProvider;

  OrderCategoryVisibilityProvider(this.orderProvider);

  bool _pendingOrderVisibility = false;
  bool _inProgressVisibility = false;
  bool _onTheWayVisibility = false;
  bool _completedOrderVisibility = false;
  bool _cancelledOrderVisibility = false;

  bool get pendingOrderVisibility => _pendingOrderVisibility;
  bool get inProgressVisibility => _inProgressVisibility;
  bool get onTheWayVisibility => _onTheWayVisibility;
  bool get completedOrderVisibility => _completedOrderVisibility;
  bool get cancelledOrderVisibility => _cancelledOrderVisibility;

  void updateVisibility() async {
    await orderProvider.loadOrders();
    _pendingOrderVisibility = orderProvider.pendingOrders.isNotEmpty;
    _inProgressVisibility = orderProvider.inProgressOrders.isNotEmpty;
    _onTheWayVisibility = orderProvider.onWayOrders.isNotEmpty;
    _completedOrderVisibility = orderProvider.completedOrders.isNotEmpty;
    _cancelledOrderVisibility = orderProvider.cancelledOrders.isNotEmpty;
    notifyListeners();
  }

  void changePendingVisibility() {
    _pendingOrderVisibility = !_pendingOrderVisibility;
    _inProgressVisibility = false;
    _onTheWayVisibility = false;
    _completedOrderVisibility = false;
    _cancelledOrderVisibility = false;
    notifyListeners();
  }

  void changeInProgressVisibility() {
    _inProgressVisibility = !_inProgressVisibility;
    _pendingOrderVisibility = false;
    _onTheWayVisibility = false;
    _completedOrderVisibility = false;
    _cancelledOrderVisibility = false;
    notifyListeners();
  }

  void changeonTheWayVisibility() {
    _onTheWayVisibility = !_onTheWayVisibility;
    _pendingOrderVisibility = false;
    _inProgressVisibility = false;
    _completedOrderVisibility = false;
    _cancelledOrderVisibility = false;
    notifyListeners();
  }

  void changeCompletedisibility() {
    _completedOrderVisibility = !_completedOrderVisibility;
    _pendingOrderVisibility = false;
    _onTheWayVisibility = false;
    _inProgressVisibility = false;
    _cancelledOrderVisibility = false;
    notifyListeners();
  }

  void changeCancelledVisibility() {
    _cancelledOrderVisibility = !_cancelledOrderVisibility;
    _pendingOrderVisibility = false;
    _onTheWayVisibility = false;
    _completedOrderVisibility = false;
    _inProgressVisibility = false;
    notifyListeners();
  }
}
