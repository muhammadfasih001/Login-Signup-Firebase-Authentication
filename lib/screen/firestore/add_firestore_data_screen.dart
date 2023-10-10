import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_page/screen/firestore/firestore_home_screen.dart';
import 'package:flutter_login_page/utils/utils.dart';
import 'package:flutter_login_page/widgets/round_button.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final addDataController = TextEditingController();
  bool circularLoader = false;
  final CollectionReference fireStore =
      FirebaseFirestore.instance.collection("users");

  addUser() async {
    try {
      setState(() {
        circularLoader = true;
      });
      String uid = DateTime.now().millisecondsSinceEpoch.toString();
      await fireStore.doc(uid).set({
        "id": uid,
        "title": addDataController.text.toString(),
      });

      Utils().toastMessage("Data add Successfully");
      setState(() {
        circularLoader = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FirestoreHomeScreen()));
    } catch (error) {
      Utils().toastMessage(error.toString());
      setState(() {
        circularLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              Image.asset(
                "assets/images/add.gif",
                width: 230,
              ),
              Form(
                child: TextFormField(
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  keyboardType: TextInputType.text,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: addDataController,
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Icon(
                        Icons.textsms_outlined,
                        size: 30,
                        color: Colors.deepPurple,
                      ),
                    ),
                    hintText: 'What is in your mind?',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.deepPurple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                circularLoader: circularLoader,
                title: "Add",
                onTap: () {
                  addUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
