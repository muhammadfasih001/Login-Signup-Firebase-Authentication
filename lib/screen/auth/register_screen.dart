import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_page/screen/auth/login_screen.dart';
import 'package:flutter_login_page/utils/utils.dart';
import 'package:flutter_login_page/widgets/round_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool circularLoader = false;
  bool _obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final contactController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference fireStore =
      FirebaseFirestore.instance.collection("users");

  hideAndShow() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void signUp() async {
    try {
      setState(() {
        circularLoader = true;
      });

      // Create a new user account with Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      // Store user information in Firestore
      // String id = DateTime.now().millisecondsSinceEpoch.toString();

      // String uid = FirebaseAuth.instance.currentUser!.uid;
      // await fireStore.doc(uid).set({
      //   "id": uid,
      //   "username": userNameController.text.toString(),
      //   "contact": contactController.text.toString(),
      //   "email": emailController.text.toString(),
      // });

      setState(() {
        Utils().toastMessage("Your account has been successfully registered");
        circularLoader = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      setState(() {
        Utils().toastMessage(error.toString());
        circularLoader = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    contactController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FB),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/signup.gif",
                  width: 230,
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: userNameController,
                        decoration: const InputDecoration(
                          labelText: 'User Name',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color.fromRGBO(103, 58, 183, 1),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your User Name';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.phone,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: contactController,
                        decoration: const InputDecoration(
                          labelText: 'Contact',
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Color.fromRGBO(103, 58, 183, 1),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Contact please';
                          }

                          // Remove any spaces, dashes, or other non-digit characters
                          String cleanedValue =
                              value.replaceAll(RegExp(r'[^0-9]'), '');

                          if (cleanedValue.length != 11) {
                            return 'Contact number should be exactly 11 digits';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        enableSuggestions: true,
                        autocorrect: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: Color.fromRGBO(103, 58, 183, 1),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.deepPurple,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email';
                          }
                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: _obsecureText,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.deepPurple,
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.deepPurple,
                          ),
                          suffixIcon: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              hideAndShow();
                            },
                            child: Icon(
                              _obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundButton(
                  circularLoader: circularLoader,
                  title: 'Register',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signUp();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account ?   ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
