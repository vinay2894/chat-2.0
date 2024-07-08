import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/auth_helper.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: GoogleFonts.labrada(
                    textStyle: TextStyle(
                      fontSize: 40,
                      color: Colors.blue.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Create your Account",
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
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: confirmPasswordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
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
                    String confirmPassword = confirmPasswordController.text;

                    if (formKey.currentState!.validate()) {
                      if (password == confirmPassword) {
                        User? user = await Auth.auth.createNewUser(
                          email: email,
                          password: password,
                        );

                        log(email);

                        if (user != null) {
                          Navigator.of(context).pushReplacementNamed(
                              'detail_page',
                              arguments: email);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password didn't Match"),
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
                      "Sign Up",
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
                      Navigator.of(context).pushReplacementNamed('home_page');
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
                      "Already have an Account ?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Text(
                        "Login",
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
      ),
    );
  }
}
