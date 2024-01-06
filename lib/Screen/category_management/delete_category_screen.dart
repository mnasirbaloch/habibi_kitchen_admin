// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/category_provider.dart';
import 'package:provider/provider.dart';

class DeleteCategoryScreen extends StatefulWidget {
  const DeleteCategoryScreen({super.key});

  @override
  State<DeleteCategoryScreen> createState() => _DeleteCategoryScreenState();
}

class _DeleteCategoryScreenState extends State<DeleteCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 01,
        title: const Text(
          "Delete Category",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), //
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 0.85,
            ),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              // print('index$index');
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                  // color: Colors.red,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                categoryProvider.categories[index].imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        categoryProvider.categories[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          bool result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: Text(
                                      'Do you want to delete category: ${categoryProvider.categories[index].name}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // Returning true when "Yes" is pressed
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Returning false when "No" is pressed
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              });
                          if (result) {
                            categoryProvider.deleteCategory(
                                categoryProvider.categories[index].name,
                                context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(2),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

//Dialog widget

