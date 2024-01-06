// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';

class CategoryProvider extends ChangeNotifier {
  final storageRef = FirebaseStorage.instance.ref();
  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menu');
  //
  CategoryLoadingState categoryLoadingState = CategoryLoadingState.Loading;

  CategoryProvider() {
    fetchCategories().then((value) {
      notifyListeners();
    });
  }
  static String errorMessage = '';

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  // Fetch categories from Firebase
  Future<void> fetchCategories() async {
    try {
      final QuerySnapshot snapshot = await menuCollection.get();
      _categories = snapshot.docs.map((doc) {
        Map data = doc.data() as Map;
        data.putIfAbsent('id', () => doc.id);
        return Category.fromMap(data as Map<String, dynamic>? ?? {});
      }).toList();

      categoryLoadingState = CategoryLoadingState.Loaded;
      notifyListeners();
    } catch (error) {
      categoryLoadingState = CategoryLoadingState.ErrorWhileLoading;
      errorMessage = error.toString();
      notifyListeners();
      print("Error fetching categories: $error");
    }
  }

  // Add a new category to Firebase
  Future<void> createNewCategory(
      {required String categoryName,
      required String imagePath,
      required BuildContext context}) async {
    try {
      bool showPictureUploading = true;
      Reference imagesRef = storageRef.child(imagePath);
      File file = File(imagePath);
      try {
        imagesRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              if (showPictureUploading) {
                showSnackBar(
                  context: context,
                  content: 'Uploading Image',
                  duration: const Duration(seconds: 5),
                  textAlign: TextAlign.center,
                );
                showPictureUploading = false;
              }
              break;
            case TaskState.paused:
              showSnackBar(
                context: context,
                content: 'Uploading Image Puased',
                duration: const Duration(seconds: 2),
                textAlign: TextAlign.center,
              );
              break;
            case TaskState.success:
              showSnackBar(
                context: context,
                content: 'Image Uploaded Successfully',
                duration: const Duration(seconds: 2),
                textAlign: TextAlign.center,
              );
              final downloadableImageUrl = await imagesRef.getDownloadURL();
              try {
                await menuCollection
                    .doc(categoryName.replaceAll(' ', '_').toLowerCase())
                    .set({
                  'name': categoryName,
                  'imageUrl': downloadableImageUrl,
                });
                menuCollection
                    .doc(categoryName.replaceAll(' ', '_'))
                    .collection('items')
                    .doc()
                    .set({
                  'name': 'dummy01',
                  'price': '000',
                  'imageUrl': downloadableImageUrl,
                  'description':
                      'Taste the essence of homemade goodness with our fresh pasta. Crafted with the finest ingredients and rolled to perfection, each bite unveils a symphony of flavors that will transport you to culinary bliss.'
                });
                fetchCategories();
                notifyListeners();
                Navigator.of(context).popUntil((route) => route.isFirst);
                showSnackBar(
                    context: context,
                    content: 'Category Created  Successfully',
                    textAlign: TextAlign.center);
              } catch (error) {
                showSnackBar(
                  context: context,
                  content: 'Error Occurred: $error',
                  textAlign: TextAlign.center,
                );
                print("Error updating category name: $error");
              }
              break;
            case TaskState.canceled:
              showSnackBar(
                context: context,
                content: 'Task Cancelled',
                duration: const Duration(seconds: 1),
                textAlign: TextAlign.center,
              );
              break;
            case TaskState.error:
              showSnackBar(
                context: context,
                content: 'Error Occured While Uploading Image',
                textAlign: TextAlign.center,
                duration: const Duration(seconds: 1),
              );
              break;
          }
        });
      } catch (error) {
        showSnackBar(
          context: context,
          content: 'Error Occurred: $error',
          textAlign: TextAlign.center,
        );
        // print("Error updating category name: $error");
      }
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occurred: $error',
        textAlign: TextAlign.center,
      );
      // print("Error updating category name: $error");
    }
  }

  List<String> getCategoriesNames() {
    List<String> categoryNameList = [];
    for (int i = 0; i < _categories.length; i++) {
      categoryNameList.add(_categories[i].name);
    }
    return categoryNameList;
  }

  // Update the name of a category in Firebase
  Future<void> updateCategoryName(
      String categoryName, String newName, BuildContext context) async {
    try {
      final Query query = menuCollection.where('name', isEqualTo: categoryName);
      final QuerySnapshot querySnapshot = await query.get();

      for (DocumentSnapshot categoryDoc in querySnapshot.docs) {
        await categoryDoc.reference.update({'name': newName});
      }
      fetchCategories();
      notifyListeners();
      Navigator.of(context).popUntil((route) => route.isFirst);
      showSnackBar(
        context: context,
        content: 'Updated Successfully',
        textAlign: TextAlign.center,
      );
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occurred: $error',
        textAlign: TextAlign.center,
      );
      print("Error updating category name: $error");
    }
  }

  // Update the image of a category in Firebase
  Future<void> updateCategoryImage({
    required String categoryName,
    required BuildContext context,
    required String fileName,
    required String filePath,
  }) async {
    bool showPictureUploading = true;
    // Create a child reference
// imagesRef now points to "images"
    Reference imagesRef = storageRef.child(fileName);
    File file = File(filePath);
    try {
      imagesRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (showPictureUploading) {
              showSnackBar(
                context: context,
                content: 'Uploading Image',
                duration: const Duration(seconds: 5),
                textAlign: TextAlign.center,
              );
              showPictureUploading = false;
            }
            break;
          case TaskState.paused:
            showSnackBar(
              context: context,
              content: 'Uploading Image Puased',
              duration: const Duration(seconds: 2),
              textAlign: TextAlign.center,
            );
            break;
          case TaskState.success:
            showSnackBar(
              context: context,
              content: 'Image Uploaded Successfully',
              duration: const Duration(seconds: 2),
              textAlign: TextAlign.center,
            );
            final downloadableImageUrl = await imagesRef.getDownloadURL();
            try {
              final Query query =
                  menuCollection.where('name', isEqualTo: categoryName);
              final QuerySnapshot querySnapshot = await query.get();

              for (DocumentSnapshot categoryDoc in querySnapshot.docs) {
                await categoryDoc.reference.update({
                  'imageUrl': downloadableImageUrl,
                });
              }
              fetchCategories();
              notifyListeners();
              Navigator.of(context).popUntil((route) => route.isFirst);
              showSnackBar(
                  context: context,
                  content: 'Updated Successfully',
                  textAlign: TextAlign.center);
            } catch (error) {
              showSnackBar(
                context: context,
                content: 'Error Occurred: $error',
                textAlign: TextAlign.center,
              );
              print("Error updating category name: $error");
            }
            break;
          case TaskState.canceled:
            showSnackBar(
              context: context,
              content: 'Task Cancelled',
              duration: const Duration(seconds: 1),
              textAlign: TextAlign.center,
            );
            break;
          case TaskState.error:
            showSnackBar(
              context: context,
              content: 'Error Occured While Uploading Image',
              textAlign: TextAlign.center,
              duration: const Duration(seconds: 1),
            );
            break;
        }
      });
    } catch (e) {
      showSnackBar(
        context: context,
        textAlign: TextAlign.center,
        content: 'Problem Occured While Uploading Image ${e.toString()}',
      );
    }
  }

  // Delete a category from Firebase
  Future<void> deleteCategory(String categoryName, BuildContext context) async {
    try {
      final DocumentReference categoryRef =
          menuCollection.doc(categoryName.replaceAll(' ', '_').toLowerCase());
      await categoryRef.delete();
      fetchCategories();
      notifyListeners();
      Navigator.of(context).popUntil((route) => route.isFirst);
      showSnackBar(context: context, content: 'Category Removed Successfully');
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occured While Deleting Category $categoryName: $error',
        textAlign: TextAlign.center,
      );
      print('Error Occured While Deleting Category $categoryName: $error');
    }
  }

  Future<void> updateCategory({
    required String categoryName,
    required String newName,
    required BuildContext context,
    required String fileName,
    required String filePath,
  }) async {
    try {
      final Query query = menuCollection.where('name', isEqualTo: categoryName);
      final QuerySnapshot querySnapshot = await query.get();

      for (DocumentSnapshot categoryDoc in querySnapshot.docs) {
        await categoryDoc.reference.update({'name': newName});
      }

      // Update the image
      Reference imagesRef = storageRef.child(fileName);
      File file = File(filePath);

      try {
        await imagesRef.putFile(file);
        final downloadableImageUrl = await imagesRef.getDownloadURL();

        for (DocumentSnapshot categoryDoc in querySnapshot.docs) {
          await categoryDoc.reference.update({
            'imageUrl': downloadableImageUrl,
          });
        }

        fetchCategories();
        notifyListeners();
        Navigator.of(context).popUntil((route) => route.isFirst);
        showSnackBar(
            context: context, content: 'Category Updated Successfully');
      } catch (error) {
        showSnackBar(
          context: context,
          content: 'Error Occurred: $error',
          textAlign: TextAlign.center,
        );
        print("Error updating category image: $error");
      }
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occurred: $error',
        textAlign: TextAlign.center,
      );
      print("Error updating category name: $error");
    }
  }

  // Add a new item to a category in Firebase
  Future<void> addItemToCategory(
      String categoryName, CategoryItem newItem, BuildContext context) async {
    try {
      final CollectionReference itemsCollection =
          menuCollection.doc(categoryName).collection('items');
      await itemsCollection.add(
        newItem.toMap(),
      );
      notifyListeners();
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occured: $error',
        textAlign: TextAlign.center,
      );
      print("Error adding item to category: $error");
    }
  }

  // Update an item in a category in Firebase
  Future<void> updateItemInCategory(String categoryName, String itemName,
      CategoryItem updatedItem, BuildContext context) async {
    try {
      final CollectionReference itemsCollection =
          menuCollection.doc(categoryName).collection('items');
      final QuerySnapshot snapshot =
          await itemsCollection.where('name', isEqualTo: itemName).get();
      if (snapshot.size > 0) {
        final itemDoc = snapshot.docs[0];
        await itemDoc.reference.update(updatedItem.toMap());
      }
      notifyListeners();
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occured: $error',
        textAlign: TextAlign.center,
      );
      print("Error updating item in category: $error");
    }
  }

  // Remove an item from a category in Firebase
  Future<void> removeItemFromCategory(
      String categoryName, String itemName, BuildContext context) async {
    try {
      final CollectionReference itemsCollection =
          menuCollection.doc(categoryName).collection('items');
      final QuerySnapshot snapshot =
          await itemsCollection.where('name', isEqualTo: itemName).get();
      if (snapshot.size > 0) {
        final itemDoc = snapshot.docs[0];
        await itemDoc.reference.delete();
      }
      notifyListeners();
    } catch (error) {
      showSnackBar(
        context: context,
        content: 'Error Occured: $error',
        textAlign: TextAlign.center,
      );
      print("Error removing item from category: $error");
    }
  }

  Category? getCategoryByName(
      {required String categoryName, required BuildContext context}) {
    try {
      return _categories.firstWhere((element) => element.name == categoryName);
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'Category with name $categoryName not found',
        textAlign: TextAlign.center,
      );
      return null;
    }
  }
}

// Model Classes

class Category {
  String name;
  String id;
  List<CategoryItem> items;
  String imageUrl;

  Category(
      {required this.id,
      required this.name,
      required this.items,
      required this.imageUrl});

  // Convert the Category object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Create a Category object from a map
  factory Category.fromMap(Map<String, dynamic> map) {
    final itemsList = List<CategoryItem>.from(
      map['items']?.map((item) => CategoryItem.fromMap(item)) ?? [],
    );
    return Category(
      id: map['id'],
      imageUrl: map['imageUrl'],
      name: map['name'],
      items: itemsList,
    );
  }

  // Get a list of category names
  static List<String> getCategoryNames(List<Category> categories) {
    return categories.map((category) => category.name).toList();
  }

  // Get a list of item names for a specific category
  static List<String> getItemNames(Category category) {
    return category.items.map((item) => item.name).toList();
  }
}

class CategoryItem {
  String name;
  double price;
  String imageUrl;
  String description;

  CategoryItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // Convert the CategoryItem object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // Create a CategoryItem object from a map
  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }
}

enum CategoryLoadingState {
  Loading,
  Loaded,
  ErrorWhileLoading;
}
