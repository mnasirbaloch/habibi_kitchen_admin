// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/active_index_provider.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Providers/category_provider.dart';
import '../../Providers/menu_provider.dart';

class InsertMenuItemScreen extends StatefulWidget {
  const InsertMenuItemScreen({super.key});

  @override
  State<InsertMenuItemScreen> createState() => _InsertMenuItemScreenState();
}

class _InsertMenuItemScreenState extends State<InsertMenuItemScreen> {
  bool isInProgress = false;
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  late CategoryProvider categoryProvider;
  late List<DropdownMenuItem> dropDownItems;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void didChangeDependencies() async {
    categoryProvider = Provider.of<CategoryProvider>(
      context,
    );
    await categoryProvider.fetchCategories();
    // selectedCategory = selectedCategory ?? categoryProvider.categories[0].id;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    descriptionEditingController.text =
        'Prepare yourself for a tantalizing culinary adventure with our mouthwatering Shawarma. Bursting with flavors and inspired by Middle Eastern cuisine, our Shawarma is a true delight for your taste buds..';
    String? imagePath;
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
            "Add Menu Item",
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
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 250,
              child: image != null
                  ? Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 250,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: FileImage(
                            File(image!.path),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(),
                    )
                  : Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      width: MediaQuery.sizeOf(context).width,
                      height: 250,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/habibi-kitchen.appspot.com/o/pic_image.png?alt=media&token=e63a49ec-3b41-4635-b22e-93d21dc9bbf2"),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Container(),
                    ),
            ),
            TextButton(
              onPressed: () async {
                image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(
                  () {},
                );
              },
              child: const Text(
                "Choose Image",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      createTextFormField(
                        value: "",
                        labelName: 'Item Name',
                        controller: nameEditingController,
                        minLines: 1,
                        maxLines: 1,
                        validator: (value) {
                          return value == null
                              ? 'Name field can\'t be null'
                              : value.isEmpty
                                  ? 'Name can\'t be empty'
                                  : value.length <= 3
                                      ? 'Name length must be greater than 3'
                                      : null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      createTextFormField(
                        value: '',
                        labelName: 'Price',
                        controller: priceEditingController,
                        textInputType: TextInputType.number,
                        minLines: 1,
                        maxLines: 1,
                        validator: (value) {
                          return value == null
                              ? 'Price field can\'t be null'
                              : value.isEmpty
                                  ? 'Price can\'t be empty'
                                  : null;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      DropdownButton<String>(
                        hint: const Text('Choose Category'),
                        value:
                            selectedCategory, // Assign the value for the DropdownButton
                        items: menuProvider.categories.map((category) {
                          return DropdownMenuItem(
                            value: category
                                .id, // Assign a value to each DropdownMenuItem
                            child: Text(category.id),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {});
                          selectedCategory = newValue ?? selectedCategory;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      createTextFormField(
                        value: '',
                        labelName: 'Description',
                        controller: descriptionEditingController,
                        minLines: 4,
                        maxLines: 4,
                        maxLength: 300,
                        validator: (value) {
                          return value == null
                              ? 'Description field can\'t be null'
                              : value.isEmpty
                                  ? 'Description can\'t be empty'
                                  : value.length < 150 || value.length > 300
                                      ? 'Description length must be between 150 - 300'
                                      : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: isInProgress
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () async {
                        if (!isInProgress) {
                          isInProgress = !isInProgress;
                          setState(() {});
                          try {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              showSnackBar(
                                  context: context,
                                  content:
                                      'No Internet Connection Please Try Again');
                              isInProgress = !isInProgress;
                              setState(() {});
                              return;
                            }
                          } catch (error) {
                            showSnackBar(
                                context: context,
                                content: 'Error Occured:$error');
                            isInProgress = !isInProgress;
                            setState(() {});
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            bool isDebug =
                                const bool.fromEnvironment('dart.vm.debug');
                            if (isDebug) {
                              showSnackBar(
                                  context: context,
                                  content: 'Form Validated Successfully',
                                  textAlign: TextAlign.center);
                            }
                            //insert new item in data base
                            if (selectedCategory == null) {
                              showSnackBar(
                                  context: context,
                                  content: 'Please choose category first');
                              isInProgress = !isInProgress;
                              setState(() {});
                              return;
                            }
                            if (image != null) {
                              try {
                                imagePath =
                                    await menuProvider.uploadMenuItemImage(
                                  context: context,
                                  fileName: nameEditingController.text
                                      .replaceAll(' ', '_'),
                                  filePath: image!.path,
                                );
                              } catch (error) {
                                showSnackBar(
                                    context: context,
                                    content: "Error Message: $error");
                                isInProgress = !isInProgress;
                                setState(() {});
                                return;
                              }
                              showSnackBar(
                                  context: context,
                                  content: 'Image Uploaded Successfully');
                              try {
                                await menuProvider.addNewMenuItem(
                                    categoryId: selectedCategory!,
                                    newItemData: {
                                      'name': nameEditingController.text,
                                      'price': priceEditingController.text,
                                      'imageUrl': imagePath,
                                      'description':
                                          descriptionEditingController.text,
                                    },
                                    buildContext: context);
                                showSnackBar(
                                    context: context,
                                    content: "Item Added Successfully");
                              } catch (e) {
                                showSnackBar(
                                    context: context,
                                    content:
                                        "error inserting new item: message=>${e.toString()}");
                              }
                              isInProgress = !isInProgress;
                              setState(() {});
                              return;
                            } else {
                              showSnackBar(
                                  context: context,
                                  content: 'Please choose image first');
                              isInProgress = !isInProgress;
                              setState(() {});
                              return;
                            }
                          } else {
                            showSnackBar(
                                context: context,
                                content: 'Please add required info');
                            isInProgress = !isInProgress;
                            setState(() {});
                            return;
                          }
                        } else {
                          showSnackBar(
                              context: context,
                              content: 'Process already in Progress');
                          return;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Insert Menu Item",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  TextFormField createTextFormField(
      {required String value,
      required labelName,
      required TextEditingController controller,
      TextInputType? textInputType,
      int? minLines,
      int? maxLines,
      int? maxLength,
      String? Function(String? value)? validator}) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      maxLength: maxLength,
      keyboardType: textInputType ?? TextInputType.text,
      scrollPadding: EdgeInsets.zero,
      decoration: InputDecoration(
        label: Text(labelName),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      validator: validator,
    );
  }

  void setDefaultValues(MenuItem menuItem) {
    nameEditingController.text = menuItem.name;
    priceEditingController.text = menuItem.price;
    descriptionEditingController.text = menuItem.description;
  }
}
