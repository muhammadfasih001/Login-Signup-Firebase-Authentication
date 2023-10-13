import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_page/screen/auth/login_screen.dart';
import 'package:flutter_login_page/screen/firestore/add_firestore_data_screen.dart';
import 'package:flutter_login_page/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FirestoreHomeScreen extends StatefulWidget {
  const FirestoreHomeScreen({super.key});

  @override
  State<FirestoreHomeScreen> createState() => _FirestoreHomeScreenState();
}

class _FirestoreHomeScreenState extends State<FirestoreHomeScreen> {
  final updateController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection("users").snapshots();
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("users");

  bool showMessage = true;

  Future<void> signOut() async {
    try {
      await auth.signOut();
      Utils().toastMessage("Sign Out");

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  delete(DocumentSnapshot data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm delete"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancle"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                try {
                  ref.doc(data["id"]).delete();
                  Navigator.pop(context);
                  Utils().toastMessage("Deleted Succesfully");
                } catch (error) {
                  Utils().toastMessage(error.toString());
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      }),
    );
  }

  update(DocumentSnapshot data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((BuildContext context) {
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: updateController,
            decoration: InputDecoration(
              labelText: 'Update',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Color.fromRGBO(103, 58, 183, 1),
              ),
              labelStyle: const TextStyle(
                color: Colors.deepPurple,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancle"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                try {
                  String updatedText = updateController.text;
                  ref.doc(data["id"]).update({
                    "title": updatedText,
                  });

                  Navigator.pop(context);
                  Utils().toastMessage("Updated Succesfully");
                } catch (error) {
                  Utils().toastMessage(error.toString());
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
    );
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFirestoreDataScreen()));
            },
          ),
          backgroundColor: const Color(0xffF8F9FB),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Firestore Screen",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  signOut();
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
          body: Column(
            children: [
              Image.asset(
                "assets/images/account.gif",
                width: 230,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      backgroundColor: Colors.deepPurple,
                    );
                  }

                  if (snapshot.hasError) {
                    Utils().toastMessage(
                        "An error occurred: ${snapshot.error.toString()}");
                  }

                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    if (showMessage) {
                      showMessage = false;
                      Utils().toastMessage("No data available");
                    }
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot dataIndex = snapshot.data!.docs[index];

                        if (!dataIndex.exists) {
                          Utils().toastMessage("Data does not exists");
                        }
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                label: 'Delete',
                                flex: 1,
                                icon: Icons.delete_outline,
                                backgroundColor: Colors.red,
                                onPressed: (BuildContext context) {
                                  delete(dataIndex);
                                },
                              ),
                              SlidableAction(
                                label: 'Update',
                                flex: 1,
                                icon: Icons.edit_outlined,
                                backgroundColor: Colors.deepPurple,
                                onPressed: (BuildContext context) {
                                  update(dataIndex);
                                  updateController.clear();
                                },
                              )
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.account_circle_outlined,
                              color: Colors.deepPurple,
                              size: 35,
                            ),
                            subtitle: Text(dataIndex["id"]),
                            title: Text("${dataIndex["title"]}"),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
