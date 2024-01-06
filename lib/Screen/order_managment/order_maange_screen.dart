// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/active_index_provider.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:habibi_kitchen_admin/comm_widget/order_item.dart';
import 'package:provider/provider.dart';

import '../../Providers/visibility_provider.dart';

/*
This screen will allow admin to update the status of order. The order can have following state
1. Pending
2. In Progress
3. On The Way
4. Delivered / Completed
5. Cancelled

*/
class OrderManageScreen extends StatefulWidget {
  const OrderManageScreen({super.key});

  @override
  State<OrderManageScreen> createState() => _OrderManageScreenState();
}

class _OrderManageScreenState extends State<OrderManageScreen> {
  @override
  Widget build(BuildContext context) {
//provider which will be used to update the order info, and also rebuild this widget if
//some changes made in order state.
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    OrderCategoryVisibilityProvider orderCategoryVisibilityProvider =
        Provider.of(context);
    ActiveIndexProvider activeIndexProvider =
        Provider.of<ActiveIndexProvider>(context);
    orderProvider.loadOrders();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const InkWell(
          child: Text(
            "Manage Orders",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      //singleChildScrollView so that if there is content more than screen size user can scroll to
      //view entire content.
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Insance of OrderViewCategoryWise which represent Pending Orders
            InkWell(
              child: OrderViewCategoryWise(
                textTitle: 'Pending Orders',
                userOrder: orderProvider.pendingOrders,
                containerBgColor: const Color(0xff6DD5C5),
                onVisibilityChange:
                    orderCategoryVisibilityProvider.changePendingVisibility,
                isExpanded:
                    orderCategoryVisibilityProvider.pendingOrderVisibility,
              ),
              onTap: () {
                orderCategoryVisibilityProvider.changePendingVisibility();
              },
            ),
            //Insance of OrderViewCategoryWise which represent InProgress Orders
            InkWell(
              child: OrderViewCategoryWise(
                textTitle: 'InProgress Orders',
                userOrder: orderProvider.inProgressOrders,
                containerBgColor: const Color(0xffFDA88B),
                onVisibilityChange:
                    orderCategoryVisibilityProvider.changeInProgressVisibility,
                isExpanded:
                    orderCategoryVisibilityProvider.inProgressVisibility,
              ),
              onTap: () {
                orderCategoryVisibilityProvider.changeInProgressVisibility();
              },
            ),
            //Insance of OrderViewCategoryWise which represent OnWay Orders
            InkWell(
              child: OrderViewCategoryWise(
                textTitle: 'OnWay Orders',
                userOrder: orderProvider.onWayOrders,
                containerBgColor: const Color(0xff9BBEF4),
                onVisibilityChange:
                    orderCategoryVisibilityProvider.changeonTheWayVisibility,
                isExpanded: orderCategoryVisibilityProvider.onTheWayVisibility,
              ),
              onTap: () {
                orderCategoryVisibilityProvider.changeonTheWayVisibility();
              },
            ),
            //Insance of OrderViewCategoryWise which represent Completed Orders
            InkWell(
              child: OrderViewCategoryWise(
                textTitle: 'Completed Orders',
                userOrder: orderProvider.completedOrders,
                containerBgColor: const Color(0xffF69FD6),
                isButtonVisible: false,
                onVisibilityChange:
                    orderCategoryVisibilityProvider.changeCompletedisibility,
                isExpanded:
                    orderCategoryVisibilityProvider.completedOrderVisibility,
              ),
              onTap: () {
                orderCategoryVisibilityProvider.changeCompletedisibility();
              },
            ),
            //Insance of OrderViewCategoryWise which represent Cancelled Orders
            InkWell(
              child: OrderViewCategoryWise(
                textTitle: 'Cancelled Orders',
                userOrder: orderProvider.cancelledOrders,
                containerBgColor: const Color.fromARGB(255, 246, 159, 159),
                isButtonVisible: false,
                onVisibilityChange:
                    orderCategoryVisibilityProvider.changeCancelledVisibility,
                isExpanded:
                    orderCategoryVisibilityProvider.cancelledOrderVisibility,
              ),
              onTap: () {
                orderCategoryVisibilityProvider.changeCancelledVisibility();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Statfulwidget Widget which takes list of user items and show them in listvieew
class OrderViewCategoryWise extends StatefulWidget {
  const OrderViewCategoryWise({
    super.key,
    //title to show to user like Pending Orders
    required this.textTitle,
    //List Of UserOrder where each instance contain all information about order
    required this.userOrder,
    required this.containerBgColor,
    this.isButtonVisible,
    required this.isExpanded,
    required this.onVisibilityChange,
  });
  //list of userOrder
  final List<UserOrder> userOrder;
  final String textTitle;
  final Color containerBgColor;
  final void Function() onVisibilityChange;
  //bool field for making sure update button should be visible or not
  final bool? isButtonVisible;
  final bool isExpanded;

  @override
  State<OrderViewCategoryWise> createState() => _OrderViewCategoryWiseState();
}

class _OrderViewCategoryWiseState extends State<OrderViewCategoryWise> {
  @override
  Widget build(BuildContext context) {
    //consumer which will rebuilt if the any order state changes.
    OrderCategoryVisibilityProvider orderCategoryVisibilityProvider =
        Provider.of<OrderCategoryVisibilityProvider>(context);
    return Consumer<OrderProvider>(
      builder: (context, value, child) {
        //set isExpanded empty if list is empty
        // isExpanded = isExpanded ?? widget.userOrder.isNotEmpty;
        /*
A container which have a column as child.
Column will have two childs the Row and ListView
1. Row:
   Row will contain title which indicate type of orders and total orders

2. ListView:
   ListView will contain the orders of that specific type. Item of listView will contain order info
   and a button which allow admin to update order status.      */
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.containerBgColor,
              )
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          //a column having two child a row and listView
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.containerBgColor,
                    )
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                //Row which show the type of orders, total order in  that type and button to expand /shrink items view.
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.textTitle} (${widget.userOrder.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onVisibilityChange,
                      // onPressed: () {
                      //   // isExpanded = !isExpanded!;
                      //   // setState(() {});
                      // },
                      icon: widget.isExpanded
                          ? const Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 30,
                            )
                          : const Icon(
                              Icons.arrow_right,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              ),
              //visibility widget which show child only if visibility is set to true.
              Visibility(
                visible: widget.isExpanded,
                /*
                If list is empty the child will be a container with column having an icon and text that  show
                message that "No element exist in this type of category"
                */
                child: widget.userOrder.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "No Order Exist In This Category",
                                style: getTextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    /*
                If list is not empty it a ListView will be returned in which each item show an individual order
                of that category
                */
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.userOrder.length,
                        itemBuilder: (context, index) {
/*
If admin clicks on item he will move on to order-info screen where admin can see all info related
to order.
*/
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/showOrderInfo',
                                arguments: widget.userOrder[index],
                              );
                            },
                            child: OrderItemView(
                              index: index,
                              order: widget.userOrder[index],
                              color: widget.containerBgColor,
                              isButtonVisible: widget.isButtonVisible,
                              orderItemList: widget.userOrder[index].orderItems,
                              //if admin press update button, admin will move to update screen where admin
                              //can update status of order
                              onUpdatePressed: () {
                                Navigator.of(context).pushNamed(
                                  '/updateOrderScreen',
                                  arguments: widget.userOrder[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}

// ignore: constant_identifier_names
enum OrderType { PendingOrders, InProgressOrders, OnWayOrders, CompletedOrders }
