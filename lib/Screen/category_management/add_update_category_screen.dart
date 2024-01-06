import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habibi_kitchen_admin/Providers/category_provider.dart';
import 'package:habibi_kitchen_admin/comm_widget/common_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddUpdateCategoryScreen extends StatefulWidget {
  const AddUpdateCategoryScreen({super.key});
  @override
  State<AddUpdateCategoryScreen> createState() =>
      _AddUpdateCategoryScreenState();
}

class _AddUpdateCategoryScreenState extends State<AddUpdateCategoryScreen> {
  bool isInProgress = false;
  String? dropDownValue;
  TextEditingController nameEditingController = TextEditingController();
  ImagePicker picker = ImagePicker();
  Category? category;
  XFile? image;
  @override
  Widget build(BuildContext context) {
    //check if argumnet is non-null it means admin click add-category button
    final bool? isAddCategoryArgument =
        ModalRoute.of(context)?.settings.arguments as bool?;
    //assign true / false depending on above argument to user later for different conditions.
    final bool isAddCategory = isAddCategoryArgument ?? false;
    late ImageProvider myAssetImage;
    if (isAddCategory) {
      myAssetImage = const AssetImage('assets/images/pic_an_image.png');
    }
    //category provider which provides the list of categories info which will be used to show data to admin when he
    //wants to update data of specific category
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          isAddCategory == true ? "Add Category" : "Update Category",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), //
      ),
      body: isAddCategory == true
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 250,
                    child: image != null
                        ? Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
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
                            width: MediaQuery.sizeOf(context).width,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: isAddCategory == false
                                    ? NetworkImage(
                                        category?.imageUrl ??
                                            'https://image.shutterstock.com/image-vector/dotted-spiral-vortex-royaltyfree-images-600w-2227567913.jpg',
                                      )
                                    : myAssetImage,
                              ),
                            ),
                            child: Container(),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(
                        () {},
                      );
                    },
                    child: const Text("Change Image"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameEditingController,
                    decoration: const InputDecoration(
                      // label: const Text('Category Name'),
                      labelText: "Category Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (isInProgress) {
                        showSnackBar(
                          context: context,
                          content: 'Please Wiat Already In Progress.',
                          textAlign: TextAlign.center,
                        );
                        return;
                      }
                      if (image != null &&
                          nameEditingController.text.isNotEmpty) {
                        showSnackBar(
                            context: context, content: 'Creating new category');
                        categoryProvider.createNewCategory(
                            categoryName: nameEditingController.text,
                            imagePath: image!.path,
                            context: context);
                      } else if (image == null) {
                        showSnackBar(
                            context: context,
                            content:
                                'Please pick and Image to create new category');
                      } else if (nameEditingController.text.isEmpty) {
                        showSnackBar(
                            context: context,
                            content: 'Please enter the name of category');
                      }
                    },
                    child: const Text("Add Category"),
                  )
                ],
              ),
            )
          //below codew will only be executed when admin wants to update the category
          : categoryProvider.categoryLoadingState ==
                  CategoryLoadingState.Loading
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Content is Loaidng Please Wait"),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                )
              //below code will be executed when all categories are fetched from database and ready to show detail about category
              //to user
              : categoryProvider.categoryLoadingState ==
                      CategoryLoadingState.Loaded
                  ? Container(
                      child: categoryProvider.categories.isEmpty
                          ? const Center(
                              child: Text("No Category Found"),
                            )
                          : Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Select Category to Update",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InputDecorator(
                                    // Wrap the DropdownButton in InputDecorator
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ), // Hide default underline
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff9BBEF4),
                                      ),
                                      child: DropdownButton<String>(
                                        value: dropDownValue ??
                                            (dropDownValue = categoryProvider
                                                .categories[0].name),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        dropdownColor: const Color(0xff9BBEF4),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        onChanged: (String? value) {
                                          print("onchanged invoked");
                                          setState(() {
                                            print('$value');
                                            dropDownValue = value;
                                            category = categoryProvider
                                                .getCategoryByName(
                                                    categoryName: value!,
                                                    context: context);
                                            image = null;
                                          });
                                        },
                                        items: categoryProvider.categories
                                            .map((e) {
                                          print("inoked2");
                                          category = category ??
                                              categoryProvider
                                                  .getCategoryByName(
                                                      categoryName:
                                                          categoryProvider
                                                              .categories[0]
                                                              .name,
                                                      context: context);
                                          nameEditingController.text =
                                              category!.name;
                                          print(category?.name);
                                          return DropdownMenuItem<String>(
                                            value: e.name,
                                            child: Center(
                                              child: Text(e.name),
                                            ), // Center the option names
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 250,
                                          child: image != null
                                              ? Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
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
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    image: DecorationImage(
                                                      image:
                                                          isAddCategory == false
                                                              ? NetworkImage(
                                                                  category?.imageUrl ??
                                                                      'https://image.shutterstock.com/image-vector/dotted-spiral-vortex-royaltyfree-images-600w-2227567913.jpg',
                                                                )
                                                              : myAssetImage,
                                                    ),
                                                  ),
                                                  child: Container(),
                                                ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              image = await picker.pickImage(
                                                source: ImageSource.gallery,
                                              );
                                              setState(
                                                () {},
                                              );
                                            } catch (e) {
                                              print(e.toString());
                                            }
                                          },
                                          child: const Text("Change Image"),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: nameEditingController,
                                          decoration: const InputDecoration(
                                            // label: const Text('Category Name'),
                                            labelText: "Category Name",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (isInProgress) {
                                              showSnackBar(
                                                context: context,
                                                content:
                                                    'Please Wiat Already In Progress.',
                                                textAlign: TextAlign.center,
                                              );
                                              return;
                                              // else-if block will run when admin is in update-category mode, instead of adding new one.
                                            } else if (!isAddCategory) {
                                              isInProgress = true;
                                              if (nameEditingController.text ==
                                                      category!.name &&
                                                  image == null) {
                                                showSnackBar(
                                                  context: context,
                                                  content:
                                                      'Please update name or picture first',
                                                  textAlign: TextAlign.center,
                                                );
                                                isInProgress = false;
                                              } else if (nameEditingController
                                                          .text !=
                                                      category!.name &&
                                                  image != null) {
                                                // print("update both image and name");
                                                await categoryProvider
                                                    .updateCategory(
                                                        categoryName:
                                                            category!.name,
                                                        newName:
                                                            nameEditingController
                                                                .text,
                                                        context: context,
                                                        fileName:
                                                            nameEditingController
                                                                .text,
                                                        filePath: image!.path);
                                                isInProgress = false;
                                              } else if (nameEditingController
                                                      .text ==
                                                  category!.name) {
                                                // print("update  image");
                                                await categoryProvider
                                                    .updateCategoryImage(
                                                  categoryName: category!.name,
                                                  context: context,
                                                  fileName: category!.name
                                                      .replaceAllMapped(
                                                          ' ', (match) => '_'),
                                                  filePath: image!.path,
                                                );
                                                isInProgress = false;
                                              } else {
                                                // print("update name data");
                                                await categoryProvider
                                                    .updateCategoryName(
                                                        category!.name,
                                                        nameEditingController
                                                            .text,
                                                        context);
                                                isInProgress = false;
                                              }
                                              // the else block will be executed when admin wants to add new category
                                            } else {
                                              print("Add category");
                                            }
                                          },
                                          child: const Text("Update"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(30),
                      color: Colors.grey,
                      child: Center(
                        child: Text(
                          '''Error While Loaidng! Please Check your interent connection
${CategoryProvider.errorMessage}''',
                        ),
                      ),
                    ),
    );
  }
}
