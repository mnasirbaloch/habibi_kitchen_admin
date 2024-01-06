import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/login_provider.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:provider/provider.dart';

import 'menu_managment/menu_manage_screen.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: InkWell(
          child: const Text(
            "Home Admin",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          onLongPress: () {
            loginProvider.logOutUserStoreInfoInSharedPreferences();
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 1,
              color: Colors.black.withOpacity(0.2),
              // margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).width * 0.32,
              child: buildCategoryTile(
                // imageUrl: 'assets/images/manage_order.png',
                context: context,
                iconData: Icons.card_travel,
                title: 'Manage Order',
                onTap: () {
                  Navigator.of(context).pushNamed('/orderManageScreen');
                },
                color: const Color(0xff8EC7D3),
                iconBgColor: const Color(0xff2BA8C2),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).width * 0.32,
              child: buildCategoryTile(
                // imageUrl: 'assets/images/manage_order.png',
                context: context,
                iconData: Icons.menu_book,
                title: 'Manage Menu',
                onTap: () {
                  Navigator.of(context).pushNamed('/menuManageScreen');
                },
                color: const Color(0xffBCA1F2),
                iconBgColor: const Color(0xff7D4AE4),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).width * 0.32,
              child: buildCategoryTile(
                // imageUrl: 'assets/images/manage_order.png',
                context: context,
                iconData: Icons.analytics_outlined,
                title: 'Reports',
                onTap: () {
                  Navigator.of(context).pushNamed('/reportScreen');
                },
                color: const Color(0xffA0D69A),
                iconBgColor: const Color(0xff55C549),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
                top: 10,
              ),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Today Statics",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildTodayInfoRow(
                iconData: Icons.pending,
                title: "Pending Orders",
                count: orderProvider.pendingOrders
                    .where((element) {
                      DateTime now = DateTime.now();
                      return (element.timestamp.toDate()).month == now.month &&
                          (element.timestamp.toDate()).day == now.day;
                    })
                    .length
                    .toString(),
                color: const Color(0xff8EC7D3),
                iconBgColor: const Color(0xff2BA8C2),
                onTap: () {}),
            buildTodayInfoRow(
              iconData: Icons.build_circle_sharp,
              title: "In Progress",
              color: const Color(0xffBCA1F2),
              iconBgColor: const Color(0xff7D4AE4),
              count: orderProvider.inProgressOrders
                  .where((element) {
                    DateTime now = DateTime.now();
                    return (element.timestamp.toDate()).month == now.month &&
                        (element.timestamp.toDate()).day == now.day;
                  })
                  .length
                  .toString(),
              onTap: () {},
            ),
            buildTodayInfoRow(
              iconData: Icons.done,
              title: "Completed",
              color: const Color(0xffA0D69A),
              iconBgColor: const Color(0xff55C549),
              count: orderProvider.completedOrders
                  .where((element) {
                    DateTime now = DateTime.now();
                    return (element.timestamp.toDate()).month == now.month &&
                        (element.timestamp.toDate()).day == now.day;
                  })
                  .length
                  .toString(),
              onTap: () {},
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Widget buildTodayInfoRow({
  required IconData iconData,
  // required String imageUrl,
  required String title,
  required String count,
  Color color = Colors.grey,
  Color iconBgColor = Colors.transparent,
  required void Function() onTap,
}) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color,
        ),
      ],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          // margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconBgColor,
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            count,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
