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

class UpdateMenuItemScreen extends StatefulWidget {
  const UpdateMenuItemScreen({super.key});

  @override
  State<UpdateMenuItemScreen> createState() => _UpdateMenuItemScreenState();
}

class _UpdateMenuItemScreenState extends State<UpdateMenuItemScreen> {
  bool isInProgress = false;
  final _formKey = GlobalKey<FormState>();
  String? dropDownValue;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? image;
  @override
  Widget build(BuildContext context) {
    String? imagePath;
    MenuProvider menuProvider = Provider.of<MenuProvider>(context);
    ActiveIndexProvider activeIndexProvider =
        Provider.of<ActiveIndexProvider>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(
      context,
    );
    final menuItem = ModalRoute.of(context)!.settings.arguments as MenuItem;
    if (nameEditingController.text.isEmpty) {
      setDefaultValues(menuItem);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const InkWell(
          child: Text(
            "Update Menu Item",
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(menuItem.imageUrl),
                          fit: BoxFit.cover,
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
                "Change Image",
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
                        value: menuItem.name,
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
                        value: menuItem.price,
                        labelName: 'Price',
                        controller: priceEditingController,
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
                        height: 20,
                      ),
                      createTextFormField(
                        value: menuItem.price,
                        labelName: 'Description',
                        maxLength: 300,
                        controller: descriptionEditingController,
                        minLines: 4,
                        maxLines: 4,
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
                              return;
                            }
                          } catch (error) {
                            showSnackBar(
                                context: context,
                                content: 'Error Occured:$error');
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
                            if (image == null &&
                                menuItem.name == nameEditingController.text &&
                                menuItem.price == priceEditingController.text &&
                                menuItem.description ==
                                    descriptionEditingController.text) {
                              showSnackBar(
                                  context: context,
                                  content: 'There Is No Field To Update',
                                  textAlign: TextAlign.center);
                              isInProgress = !isInProgress;
                              setState(() {});
                            } else {
                              showSnackBar(
                                  context: context,
                                  content: 'Updating Data,Please Wiat',
                                  textAlign: TextAlign.center);

                              if (image != null) {
                                print("Uploading image");
                                try {
                                  imagePath =
                                      await menuProvider.uploadMenuItemImage(
                                    context: context,
                                    fileName:
                                        menuItem.name.replaceAll(' ', '_'),
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
                                if (imagePath == "409") {
                                  showSnackBar(
                                      context: context,
                                      content: 'Image Upload Faild Try Again');
                                  isInProgress = !isInProgress;
                                  setState(() {});
                                  return;
                                }
                              } else {
                                imagePath = menuItem.imageUrl;
                              }
                              print(
                                  "active index:${activeIndexProvider.activeIndex}");
                              print(
                                  "active index name:${activeIndexProvider.categoryName}");
                              print("image: $imagePath image:${image?.path}");
                              await menuProvider.updateAllMenuItemFields(
                                categoryId: activeIndexProvider.categoryName
                                    .replaceAll(' ', '_')
                                    .replaceAll(' ', '_')
                                    .toLowerCase(),
                                menuItemId: menuItem.id,
                                updatedMenuItem: MenuItem(
                                  id: menuItem.id,
                                  name: nameEditingController.text,
                                  price: priceEditingController.text,
                                  imageUrl: imagePath!,
                                  description:
                                      descriptionEditingController.text,
                                ),
                                buildContext: context,
                              );
                              isInProgress = !isInProgress;
                            }
                          } else {
                            showSnackBar(
                                context: context,
                                content:
                                    'Please fill in all the deatil to continue');
                            isInProgress = !isInProgress;
                            setState(() {});
                          }
                        } else {
                          showSnackBar(
                              context: context,
                              content: 'Process already in Progress');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: const Text(
                          "Update Menu Item",
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
      int? minLines,
      int? maxLines,
      int? maxLength,
      String? Function(String? value)? validator}) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
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
      maxLength: maxLength,
    );
  }

  void setDefaultValues(MenuItem menuItem) {
    nameEditingController.text = menuItem.name;
    priceEditingController.text = menuItem.price;
    descriptionEditingController.text = menuItem.description;
  }
}
