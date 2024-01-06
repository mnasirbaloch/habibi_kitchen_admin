// ignore_for_file: invalid_return_type_for_catch_error, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';

class MenuProvider with ChangeNotifier {
  final List<Category> _categories = [];
  StreamSubscription<QuerySnapshot>? _subscription;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();
  List<Category> get categories => _categories;

  MenuProvider() {
    fetchMenu();
  }

// Method to insert a new menu item
  Future<void> addNewMenuItem({
    required String categoryId,
    required Map<String, dynamic> newItemData,
    required BuildContext buildContext,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("menu")
          .doc(categoryId)
          .collection('items')
          .add(newItemData);
      showSnackBar(
          context: buildContext, content: 'New Menu Item Added Successfully');
      await fetchMenu();
      notifyListeners();
      Navigator.of(buildContext).pop();
      print('New Menu Item added successfully');
    } catch (error) {
      print('Error adding new Menu Item: $error');
      showSnackBar(
          context: buildContext,
          content: 'Addition Failed > Error: ${error.toString()}');
    }
  }

  //a method which fetch categories and there items from firebase
  Future<void> fetchMenu() async {
    await FirebaseFirestore.instance
        .collection("menu")
        .get()
        .then((querySnapshot) {
      print("Successfully completed");
      _categories.clear();
      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data();
        final category = Category(
          id: docSnapshot.id,
          name: data['name'],
          items: [], // Initialize items as an empty list
        );

        // Get the subcollection reference for the current document
        final subCollectionRef = docSnapshot.reference.collection('items');

        // ignore: duplicate_ignore
        subCollectionRef.get().then((subCollectionSnapshot) {
          for (var subDocSnapshot in subCollectionSnapshot.docs) {
            final subData = subDocSnapshot.data();
            final menuItem = MenuItem(
              id: subDocSnapshot.id,
              name: subData['name'],
              price: subData['price'],
              imageUrl: subData['imageUrl'],
              description: subData['description'],
            );
            if (menuItem.name != 'dummy01') {
              category.items.add(
                  menuItem); // Add the menuItem to the category's items list
            }
          }
          if (category.name == "Fast Food") {
            if (_categories.isEmpty) {
              _categories.add(category);
            } else {
              Category temp = categories.elementAt(0);
              _categories[0] = category;
              _categories.add(temp);
              notifyListeners();
            }
          } else if (category.name == "Desi Food") {
            if (_categories.length <= 1) {
              _categories.add(category);
            } else {
              Category temp = categories.elementAt(1);
              _categories[1] = category;
              _categories.add(temp);
              notifyListeners();
            }
          } else if (category.name == "Desserts") {
            if (_categories.length <= 2) {
              _categories.add(category);
            } else {
              Category temp = categories.elementAt(2);
              _categories[2] = category;
              _categories.add(temp);
              notifyListeners();
            }
          } else if (category.name == "Rice") {
            if (_categories.length <= 3) {
              _categories.add(category);
            } else {
              Category temp = categories.elementAt(3);
              _categories[3] = category;
              _categories.add(temp);
              notifyListeners();
            }
          } else {
            if (category.items.isEmpty) {
              //don't add the category which don't have any items
            } else {
              _categories.add(category);
              notifyListeners();
            }
            notifyListeners();
          }
        }).catchError((e) => print("Error retrieving subcollection: $e"));
      }
    }).catchError(
      (e) => print("Error completing: $e"),
    );
  }

//method to update single field of menuitem
  Future<void> updateMenuItemField({
    required String categoryId,
    required String menuItemId,
    required Map<String, dynamic> updatedData,
    required BuildContext buildContext,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("menu")
          .doc(categoryId)
          .collection('items')
          .doc(menuItemId)
          .update(updatedData);
      showSnackBar(
          context: buildContext, content: 'Menu Item Updated Successfully');
      await fetchMenu();
      notifyListeners();
      Navigator.of(buildContext).pop();
      print('MenuItem updated successfully');
    } catch (error) {
      print('Error updating MenuItem: $error');
      showSnackBar(
          context: buildContext,
          content: 'Updation Failed > Error: ${error.toString()}');
    }
  }

  // If you want to update all fields, you can call the updateMenuItemField method with the new data
  Future<void> updateAllMenuItemFields({
    required String categoryId,
    required String menuItemId,
    required MenuItem updatedMenuItem,
    required BuildContext buildContext,
  }) async {
    Map<String, dynamic> updatedData = {
      'name': updatedMenuItem.name,
      'price': updatedMenuItem.price,
      'imageUrl': updatedMenuItem.imageUrl,
      'description': updatedMenuItem.description,
    };

    await updateMenuItemField(
        categoryId: categoryId,
        menuItemId: menuItemId,
        updatedData: updatedData,
        buildContext: buildContext);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  //method to upload image
  // Update the image of a category in Firebase
  Future<String?> uploadMenuItemImage({
    required BuildContext context,
    required String fileName,
    required String filePath,
  }) async {
    // Create a child reference
// imagesRef now points to "images"
    Reference imagesRef = storageRef.child(fileName);
    print(imagesRef.toString());
    File file = File(filePath);
    try {
      TaskSnapshot task = await imagesRef.putFile(file);
      String downloadUrl = await task.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occured: $error',
        duration: const Duration(seconds: 2),
        textAlign: TextAlign.center,
      );
      return '409'; //code i am using to indicate the uploading process failure
    }
  }

  //method to delete menu item
  Future<void> deleteFoodItemInCategory({
    required String categoryName,
    required String foodItemId,
    required BuildContext context,
  }) async {
    try {
      // Reference to the Firestore collection "menu"
      final CollectionReference menuCollection =
          FirebaseFirestore.instance.collection('menu');
      // Reference to the specific category (document) within "menu"
      final DocumentReference categoryDocRef = menuCollection.doc(categoryName);
      // Reference to the "items" sub-collection within the category
      final CollectionReference itemsCollection =
          categoryDocRef.collection('items');
      // Reference to the specific food item document by its ID
      final DocumentReference foodItemRef = itemsCollection.doc(foodItemId);
      // Delete the food item document
      await foodItemRef.delete();
      await fetchMenu();
      showSnackBar(
          context: context,
          content:
              'Food item with ID $foodItemId deleted successfully from category $categoryName.');
      notifyListeners();
    } catch (e) {
      print('Error deleting food item: $e');
      showSnackBar(context: context, content: 'Error deleting food item: $e');
    }
  }
}

class Category {
  final String id;
  final String name;
  final List<MenuItem> items;

  Category({required this.id, required this.name, required this.items});

  factory Category.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemData = json['items'] ?? [];
    final List<MenuItem> items =
        itemData.map((item) => MenuItem.fromJson(item)).toList();

    return Category(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      description: json['decsription'],
    );
  }
  @override
  String toString() {
    return '''
Id: $id
Name: $name
Price: $price
ImageUlr: $imageUrl
''';
  }
}
