// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_login_page/screen/auth/login_screen.dart';
// import 'package:flutter_login_page/utils/utils.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final Stream<QuerySnapshot<Map<String, dynamic>>> fireStore =
//       FirebaseFirestore.instance.collection("users").snapshots();

//   void signOut() {
//     auth.signOut().then((value) {
//       setState(() {
//         Utils().toastMessage("Sign Out");
//       });
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()));
//     }).onError((error, stackTrace) {
//       Utils().toastMessage(error.toString());
//     });
//   }

//   adduser() {}

//   delete() {
//     showDialog(
//       context: context,
//       builder: ((BuildContext context) {
//         return AlertDialog(
//           title: const Text("Confirm delete"),
//           content: const Text("Are you sure you want to delete?"),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 backgroundColor: Colors.deepPurple,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancle"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () {
//                 //delete action is here
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(statusBarColor: Color(0xffF8F9FB)),
//     );
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           floatingActionButton: FloatingActionButton(
//             backgroundColor: Colors.deepPurple,
//             child: const Icon(Icons.add),
//             onPressed: () {
//               //add
//             },
//           ),
//           backgroundColor: const Color(0xffF8F9FB),
//           appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             title: const Text(
//               "Accounts",
//               style: TextStyle(
//                   color: Colors.deepPurple,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 20),
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () {
//                   signOut();
//                 },
//                 icon: const Icon(
//                   Icons.logout_outlined,
//                   color: Colors.deepPurple,
//                   size: 25,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Image.asset(
//                 "assets/images/account.gif",
//                 width: 230,
//               ),
//               StreamBuilder<QuerySnapshot>(
//                 stream: fireStore,
//                 builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   }

//                   if (snapshot.hasError) {
//                     Utils().toastMessage(
//                         "An error occurred: ${snapshot.error.toString()}");
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     Utils().toastMessage("No data available");
//                   }

//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot dataIndex = snapshot.data!.docs[index];
//                         return Slidable(
//                           endActionPane: ActionPane(
//                             motion: const DrawerMotion(),
//                             children: [
//                               SlidableAction(
//                                 label: 'Delete',
//                                 flex: 1,
//                                 icon: Icons.delete_outline,
//                                 backgroundColor: Colors.red,
//                                 onPressed: (BuildContext context) {
//                                   delete();
//                                 },
//                               ),
//                               SlidableAction(
//                                 label: 'Update',
//                                 flex: 1,
//                                 icon: Icons.edit_outlined,
//                                 backgroundColor: Colors.deepPurple,
//                                 onPressed: (BuildContext context) {
//                                   //
//                                 },
//                               )
//                             ],
//                           ),
//                           child: ListTile(
//                             leading: const CircleAvatar(
//                               backgroundColor: Colors.deepPurple,
//                             ),
//                             title: Text("${dataIndex["username"]}"),
//                             subtitle: Text(dataIndex["email"]),
//                             trailing: const Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
