import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_page/screen/auth/login_screen.dart';
import 'package:flutter_login_page/utils/utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FB),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Home Screen",
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  setState(() {
                    Utils().toastMessage("Sign Out");
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.deepPurple,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
