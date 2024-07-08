import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../models/detail_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? image;

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: GoogleFonts.labrada(
                  textStyle: TextStyle(
                    fontSize: 40,
                    color: Colors.blue.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Enter your credential to login",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: s.height * 0.06,
              ),
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter the Email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: Colors.white,
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
              ),
              SizedBox(
                height: s.height * 0.02,
              ),
              TextFormField(
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: passwordController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter the Password";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.password),
                  prefixIconColor: Colors.white,
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
              ),
              SizedBox(
                height: s.height * 0.02,
              ),
              GestureDetector(
                onTap: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  if (formKey.currentState!.validate()) {
                    User? user = await Auth.auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (user != null) {
                      Navigator.of(context).pushReplacementNamed('home_page');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email or Password !!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  height: s.height * 0.06,
                  width: s.width * 0.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: s.height * 0.02,
              ),
              const Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: s.height * 0.02,
              ),
              GestureDetector(
                onTap: () async {
                  User? user = await Auth.auth.signInWithGoogle();

                  if (user != null) {
                    DetailModal detailModal = DetailModal(
                      firstName: user.displayName as String,
                      lastName: "",
                      contact: user.phoneNumber ?? "1234567890",
                      email: user.email as String,
                      image: user.photoURL ??
                          "https://pngmart.com/files/21/Account-User-PNG-Clipart.png",
                    );

                    await FireStoreHelper.fireStoreHelper
                        .addUser(detailModal: detailModal)
                        .then(
                          (value) => Navigator.of(context)
                              .pushReplacementNamed('home_page'),
                        );
                  }
                },
                child: Container(
                  height: s.height * 0.06,
                  width: s.width * 0.6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.shade500,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Sign In with Google",
                    style: TextStyle(
                      color: Colors.blue.shade500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: s.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account ?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('signUp_page');
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
