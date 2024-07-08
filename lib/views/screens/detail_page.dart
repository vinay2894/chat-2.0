import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../controller/detail_controller.dart';
import '../../helpers/firestore_helper.dart';
import '../../models/detail_model.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});

  File? image;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Detail Page",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Directory? dir = await getExternalStorageDirectory();

              image = await Provider.of<DetailPageController>(context,
                      listen: false)
                  .image!
                  .copy("${dir!.path}/$firstName.jpg");

              DetailModal detailModal = DetailModal(
                firstName: firstName.text,
                lastName: lastName.text,
                contact: contact.text,
                email: email,
                image: image?.path ??
                    "https://www.pngmart.com/files/21/Account-User-PNG-Clipart.png",
              );
              if (formKey.currentState!.validate()) {
                FireStoreHelper.fireStoreHelper
                    .addUser(detailModal: detailModal)
                    .then(
                      (value) => Navigator.pushReplacementNamed(context, '/'),
                    );
              }
            },
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: const Alignment(0.35, 0.40),
              children: [
                Container(
                  height: s.height * 0.2,
                  width: s.width,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.indigo.shade900,
                    foregroundImage:
                        image != null ? FileImage(File(image!.path)) : null,
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.blue.shade500,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Consumer<DetailPageController>(
                          builder: (context, provider, _) {
                        return AlertDialog(
                          title: const Text("Select Method"),
                          actions: [
                            TextButton.icon(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                ImagePicker picker = ImagePicker();

                                XFile? img = await picker.pickImage(
                                  source: ImageSource.camera,
                                );

                                if (img != null) {
                                  provider.addImage(
                                    img: File(img.path),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                              ),
                              label: const Text("Camera"),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                ImagePicker picker = ImagePicker();

                                XFile? img = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );

                                if (img != null) {
                                  provider.addImage(
                                    img: File(img.path),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.image,
                              ),
                              label: const Text("Gallery"),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: s.height * 0.02,
                  ),
                  Text(
                    "First Name",
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: firstName,
                    decoration: InputDecoration(
                      hintText: "First Name",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.indigo.shade900,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter the Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: s.height * 0.01,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: lastName,
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.indigo.shade900,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter the Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: s.height * 0.01,
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: contact,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.indigo.shade900,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter the Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: s.height * 0.01,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    enabled: false,
                    initialValue: email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.indigo.shade900,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter the Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
