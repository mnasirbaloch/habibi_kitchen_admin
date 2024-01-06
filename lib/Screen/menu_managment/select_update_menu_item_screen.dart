// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/menu_provider.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:habibi_kitchen_admin/Providers/active_index_provider.dart';
import 'package:habibi_kitchen_admin/comm_widget/menu_item.dart';
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
class SelectUpdateMenuItemScreen extends StatefulWidget {
  const SelectUpdateMenuItemScreen({super.key});

  @override
  State<SelectUpdateMenuItemScreen> createState() =>
      _SelectUpdateMenuItemScreenState();
}

class _SelectUpdateMenuItemScreenState
    extends State<SelectUpdateMenuItemScreen> {
  @override
  Widget build(BuildContext context) {
//provider which will be used to update the order info, and also rebuild this widget if
//some changes made in order state.
    MenuProvider menuProvider = Provider.of<MenuProvider>(context);
    ActiveIndexProvider activeIndexProvider =
        Provider.of<ActiveIndexProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const InkWell(
          child: Text(
            "Menu Item",
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              menuProvider.categories.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Menu Items are loading please wait'),
                        CircularProgressIndicator(),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuProvider.categories.length,
                      itemBuilder: (context, index) {
                        return ItemViewCategoryWise(
                          category: menuProvider.categories[index],
                          categoryItemList:
                              menuProvider.categories[index].items,
                          containerBgColor: const Color(0xff6DD5C5),
                          onVisibilityChange: () {
                            activeIndexProvider.setActiveIndex(index);
                            activeIndexProvider
                                .setName(menuProvider.categories[index].name);
                          },
                          index: index,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

//Statfulwidget Widget which takes list of user items and show them in listvieew
class ItemViewCategoryWise extends StatefulWidget {
  const ItemViewCategoryWise({
    super.key,
    //title to show to user like Pending Orders
    required this.category,
    //List Of UserOrder where each instance contain all information about order
    required this.categoryItemList,
    required this.containerBgColor,
    required this.index,
    required this.onVisibilityChange,
  });
  //list of userOrder
  final List<MenuItem> categoryItemList;
  final Category category;
  final Color containerBgColor;

  final void Function() onVisibilityChange;
  final int index;

  @override
  State<ItemViewCategoryWise> createState() => _ItemViewCategoryWiseState();
}

class _ItemViewCategoryWiseState extends State<ItemViewCategoryWise> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MenuProvider menuProvider = Provider.of<MenuProvider>(context);
    ActiveIndexProvider activeIndexProvider =
        Provider.of<ActiveIndexProvider>(context);

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
   and a button which allow admin to update menu item.      */
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
                child: InkWell(
                  onTap: widget.onVisibilityChange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.category.name} (${widget.categoryItemList.length})',
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
                        icon: activeIndexProvider.activeIndex == widget.index
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
              ),
              //visibility widget which show child only if visibility is set to true.
              Visibility(
                visible: activeIndexProvider.activeIndex == widget.index,
                /*
                If list is empty the child will be a container with column having an icon and text that  show
                message that "No element exist in this type of category"
                */
                child: widget.categoryItemList.isEmpty
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
                              child: const Text(
                                "No Item Exist In This Category",
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
                        itemCount: widget.categoryItemList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed(
                                //   '/showOrderInfo',
                                //   arguments: widget.categoryItemList[index],
                                // );
                              },
                              child: MenuItemView(
                                index: index,
                                menuItem: widget.category.items[index],
                                color: Colors.blue,
                                onUpdatePressed: () {
                                  if (activeIndexProvider.activeIndex == 0) {
                                    activeIndexProvider.categoryName =
                                        widget.category.name;
                                  }
                                  Navigator.of(context).pushNamed(
                                    '/updateMenuItemScreen',
                                    arguments: widget.category.items[index],
                                  );
                                },
                              ));
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
