import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/controllers/category_controller.dart';
import 'package:vendor_app/controllers/product_controller.dart';
import 'package:vendor_app/controllers/subcategory_controller.dart';
import 'package:vendor_app/models/category.dart';
import 'package:vendor_app/models/subcategory.dart';
import 'package:vendor_app/provider/vendor_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;
  late String name;
  ImagePicker imagePicker = ImagePicker();
  List<File> images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late String productName;
  late double productPrice;
  late int quantity;
  late String description;
  bool isLoading = false;

  chooseImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  void initState() {
    futureCategories = CategoryController().loadCategories();
    super.initState();
  }

  void getSubcategoryByCategoryName(categoryName) {
    futureSubcategories = SubcategoryController()
        .getSubCategoriesByCategoryName(categoryName.name);
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          GridView.builder(
              shrinkWrap: true,
              itemCount: images.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                            onPressed: () {
                              chooseImage();
                            },
                            icon: const Icon(Icons.camera)),
                      )
                    : SizedBox(
                        width: 50,
                        height: 40,
                        child: Image.file(images[index - 1]),
                      );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Product Name Textformfield
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90,
                  child: TextFormField(
                    onChanged: (value) {
                      productName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product name';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Enter Product",
                        hintText: 'Enter Product Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Product Price Textformfield
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      productPrice = double.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product price';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Enter Price",
                        hintText: 'Enter Product Price',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Quantity Textformfield
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = int.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product quantity';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Enter Quantity",
                        hintText: 'Enter Product Quantity',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Choose category dropdown menu
                    FutureBuilder(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text("Categories not found"),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownButton<Category>(
                                    value: selectedCategory,
                                    hint: const Text("Select Category"),
                                    items:
                                        snapshot.data!.map((Category category) {
                                      return DropdownMenuItem(
                                          value: category,
                                          child: Text(category.name));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                      getSubcategoryByCategoryName(
                                          selectedCategory);
                                    }),
                              ),
                            );
                          }
                        }),

                    // Subcategory dropdown menu
                    FutureBuilder(
                        future: futureSubcategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text("Subcategories not found"),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownButton<Subcategory>(
                                    value: selectedSubcategory,
                                    hint: const Text("Select Subcategory"),
                                    items: snapshot.data!
                                        .map((Subcategory subcategory) {
                                      return DropdownMenuItem(
                                          value: subcategory,
                                          child: Text(
                                              subcategory.subCategoryName));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSubcategory = value;
                                      });
                                    }),
                              ),
                            );
                          }
                        }),
                  ],
                ),

                // Description Text form field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 90,
                  child: TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product description';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 5,
                    maxLength: 1000,
                    decoration: InputDecoration(
                        labelText: "Enter Description",
                        hintText: 'Enter Product Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              final vendorId = ref.read(vendorProvider)!.id;
              final fullName = ref.read(vendorProvider)!.fullName;
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await _productController
                    .uploadProduct(
                        productName: productName,
                        productPrice: productPrice,
                        quantity: quantity,
                        description: description,
                        category: selectedCategory!.name,
                        vendorId: vendorId,
                        fullName: fullName,
                        subCategory: selectedSubcategory!.subCategoryName,
                        pickedImages: images,
                        context: context)
                    .whenComplete(() {
                  setState(() {
                    isLoading = false;
                    selectedCategory = null;
                    selectedSubcategory = null;
                    images.clear();
                  });

                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter all fields')));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 90,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Upload Product",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
