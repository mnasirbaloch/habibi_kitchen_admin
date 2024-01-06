import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/category_provider.dart';
import 'package:habibi_kitchen_admin/Providers/menu_provider.dart';
import 'package:habibi_kitchen_admin/Providers/order_provider.dart';
import 'package:habibi_kitchen_admin/Providers/time_provider.dart';
import 'package:habibi_kitchen_admin/Screen/category_management/add_update_category_screen.dart';
import 'package:habibi_kitchen_admin/Screen/category_management/delete_category_screen.dart';
import 'package:habibi_kitchen_admin/Screen/home_screen.dart';
import 'package:habibi_kitchen_admin/Screen/login_screen.dart';
import 'package:habibi_kitchen_admin/Screen/menu_managment/delete_menu_item.dart';
import 'package:habibi_kitchen_admin/Screen/menu_managment/menu_manage_screen.dart';
import 'package:habibi_kitchen_admin/Screen/order_managment/order_maange_screen.dart';
import 'package:habibi_kitchen_admin/Screen/menu_managment/select_update_menu_item_screen.dart';
import 'package:habibi_kitchen_admin/Providers/active_index_provider.dart';
import 'package:habibi_kitchen_admin/Screen/report/report_screen.dart';
import 'package:provider/provider.dart';
import 'Providers/login_provider.dart';
import 'Providers/visibility_provider.dart';
import 'Screen/SplashScreen.dart';
import 'Screen/menu_managment/insert_menu_itenm.dart';
import 'Screen/menu_managment/update_menu_item_screen.dart';
import 'Screen/order_managment/show_order_info_screen.dart';
import 'Screen/order_managment/update_order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider<MyTimeProvider>(
          create: (context) => MyTimeProvider(),
        ),
        ChangeNotifierProvider<OrderCategoryVisibilityProvider>(
          create: (context) => OrderCategoryVisibilityProvider(OrderProvider()),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<MenuProvider>(
          create: (context) => MenuProvider(),
        ),
        ChangeNotifierProvider<ActiveIndexProvider>(
          create: (context) => ActiveIndexProvider(activeIndex: 0),
        ),
      ],
      child: MaterialApp(
        title: 'Habibi Kitchen Admin',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginWrapper(), // the name
          '/login': (context) =>
              const LoginScreenWidget(), // The named route for login screen
          '/home': (context) =>
              const HomeScreenWidget(), // The named route for home widget
          '/orderManageScreen': (context) =>
              const OrderManageScreen(), // The named route for home widget
          '/menuManageScreen': (context) =>
              const MenuManageScreen(), // The named route for home widget
          '/updateOrderScreen': (context) =>
              const UpdateOrderScreen(), // The named route for home widget
          '/showOrderInfo': (context) =>
              const ShowOrderInfo(), // The named route for home widget
          '/addUpdateCategory': (context) =>
              const AddUpdateCategoryScreen(), // The named route for add/update category
          '/deleteCategory': (context) =>
              const DeleteCategoryScreen(), // The named route for add/update category
          '/selectUpdateMenuItemScreen': (context) =>
              const SelectUpdateMenuItemScreen(), // The named route for add/update category
          '/updateMenuItemScreen': (context) =>
              const UpdateMenuItemScreen(), // The named route for add/update category
          '/deleteMenuItemScreen': (context) =>
              const DeleteMenuItemScreen(), // The named route for add/update category
          '/insertMenuItemScreen': (context) => const InsertMenuItemScreen(),
          '/reportScreen': (context) =>
              const ReportScreen(), // The named route for add/update category
        },
      ),
    );
  }
}
