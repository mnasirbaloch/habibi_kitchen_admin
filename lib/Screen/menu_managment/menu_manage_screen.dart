// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/login_provider.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:provider/provider.dart';
class MenuManageScreen extends StatefulWidget {
  const MenuManageScreen({super.key});

  @override
  State<MenuManageScreen> createState() => _MenuManageScreenState();
}

class _MenuManageScreenState extends State<MenuManageScreen> {
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
            "Manage Menu",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onLongPress: () {
            loginProvider.logOutUserStoreInfoInSharedPreferences();
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black), //
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(10),
              height: 10,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        context: context,
                        iconData: Icons.add_box,
                        title: 'Add Category',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/addUpdateCategory', arguments: true);
                        },
                        color: const Color(0xff6DD5C5),
                        iconBgColor: const Color(0xff1FBCA5),
                      ),
                    ),
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        context: context,
                        iconData: Icons.update_outlined,
                        title: 'Update Category',
                        onTap: () {
                          Navigator.of(context).pushNamed('/addUpdateCategory');
                        },
                        color: const Color(0xffFDA88B),
                        iconBgColor: const Color(0xffE66A40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        context: context,
                        iconData: Icons.delete,
                        title: 'Delete Category',
                        onTap: () {
                          Navigator.of(context).pushNamed('/deleteCategory');
                        },
                        color: const Color(0xff9BBEF4),
                        iconBgColor: const Color(0xff3E81E8),
                      ),
                    ),
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        iconData: Icons.add_box_sharp,
                        context: context,
                        title: 'Add Item',
                        onTap: () {
                           Navigator.of(context).pushNamed('/insertMenuItemScreen');
                        },
                        color: const Color(0xffF69FD6),
                        iconBgColor: const Color(0xffE950B1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        context: context,
                        iconData: Icons.update,
                        title: 'Update Item',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/selectUpdateMenuItemScreen');
                        },
                        color: const Color(0xffCECE5A),
                        iconBgColor: const Color(0xff1FBCA5),
                      ),
                    ),
                    Expanded(
                      child: buildCategoryTile(
                        // imageUrl: 'assets/images/manage_order.png',
                        context: context,
                        iconData: Icons.remove_circle_outline,
                        title: 'Remove Item',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/deleteMenuItemScreen');
                        },
                        color: const Color(0xffC8AE7D),
                        iconBgColor: const Color(0xffE66A40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Widget buildCategoryTile(
    {IconData iconData = Icons.add,
    String? imageUrl,
    required String title,
    required BuildContext context,
    Color color = Colors.grey,
    Color iconBgColor = Colors.transparent,
    required void Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor,
            ),
            child: imageUrl == null
                ? Icon(
                    iconData,
                    color: Colors.white,
                    size: 45,
                  )
                : Container(
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
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
        ],
      ),
    ),
  );
}
