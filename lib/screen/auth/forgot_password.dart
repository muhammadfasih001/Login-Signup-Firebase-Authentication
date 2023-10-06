import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_page/screen/auth/login_screen.dart';
import 'package:flutter_login_page/utils/utils.dart';
import 'package:flutter_login_page/widgets/round_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool circularLoader = false;
  final _auth = FirebaseAuth.instance;

  void forgotPassword() {
    setState(() {
      circularLoader = true;
    });
    _auth
        .sendPasswordResetEmail(email: emailController.text.toString())
        .then((value) {
      Utils().toastMessage(
          "We have sent your email to recover your password, please check your email");
      emailController.clear;
      setState(() {
        circularLoader = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        circularLoader = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FB),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/forgot.gif",
                  width: 230,
                ),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Enter your registered email below to receive password reset instruction \u{1F511}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      enableSuggestions: true,
                      autocorrect: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: RoundButton(
                    title: "Send",
                    circularLoader: circularLoader,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        forgotPassword();
                      }
                    },
                  ),
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
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                          fontSize: 16,
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
