// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:mycontacts/Provider/contact_provider.dart';
// import 'package:mycontacts/Provider/hide_ContactProvider.dart';
// import 'package:mycontacts/Provider/image_provider.dart';
// import 'package:mycontacts/Provider/stepper_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Contacts",
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed('fav');
//               },
//               icon: Icon(Icons.star)),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.search),
//           ),
//           PopupMenuButton(
//             itemBuilder: (context) {
//               return <PopupMenuEntry>[
//                 PopupMenuItem(
//                   onTap: () async {
//                     final LocalAuthentication auth = LocalAuthentication();
//                     bool isAuth = await auth.authenticate(
//                         localizedReason:
//                             "Please authenticate to show hidden Contacts",
//                         options: const AuthenticationOptions());
//
//                     if (isAuth) {
//                       Navigator.of(context).pushNamed('hidePage');
//                     }
//                   },
//                   child: const Text("Hidden Contacts"),
//                 ),
//                 // const PopupMenuItem(
//                 //   onTap: () {},
//                 //   child: Text("Delete"),
//                 // ),
//               ];
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return const AlertBox();
//             },
//           );
//           Provider.of<StepperProvider>(context, listen: false)
//               .nameController
//               .clear();
//           Provider.of<StepperProvider>(context, listen: false)
//               .contactController
//               .clear();
//           Provider.of<StepperProvider>(context, listen: false)
//               .emailController
//               .clear();
//
//           Provider.of<StepperProvider>(context, listen: false).step = 0;
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: (Provider.of<ContactProvider>(context).allContact.isEmpty)
//           ? Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "No Contact here",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
//               ),
//             )
//           : Consumer<ContactProvider>(
//               builder: (context, contactProvider, _) {
//                 return ListView(
//                   children: contactProvider.allContact.map((e) {
//                     return Padding(
//                       padding:
//                           const EdgeInsets.only(left: 12, right: 12, bottom: 5),
//                       child: Card(
//                         elevation: 3,
//                         child: ListTile(
//                           onTap: () {
//                             Navigator.of(context)
//                                 .pushNamed('detailPage', arguments: e);
//                           },
//                           subtitle: Row(
//                             children: [
//                               Consumer<imageProvider>(
//                                 builder: (context, imageProvider, _) {
//                                   return CircleAvatar(
//                                     radius: 30,
//                                     backgroundImage: imageProvider
//                                                 .pickImagePath !=
//                                             null
//                                         ? FileImage(
//                                             File(imageProvider.pickImagePath!),
//                                           )
//                                         : null,
//                                     child: imageProvider.pickImagePath == null
//                                         ? const Icon(Icons.person)
//                                         : null,
//                                   );
//                                 },
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 12),
//                                 child: Text(
//                                   e.name,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 22),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: () async {
//                                   await launchUrl(
//                                       Uri.parse("tel:${e.contact}"));
//                                 },
//                                 icon: const Icon(
//                                   Icons.phone,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               PopupMenuButton(
//                                 itemBuilder: (context) {
//                                   return <PopupMenuEntry>[
//                                     PopupMenuItem(
//                                       onTap: () {
//                                         Provider.of<HideContactProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .addContact(e);
//                                         Provider.of<ContactProvider>(context,
//                                                 listen: false)
//                                             .deleteContacts(e);
//                                       },
//                                       child: const Text("Hide"),
//                                     ),
//                                     PopupMenuItem(
//                                       onTap: () {
//                                         Provider.of<ContactProvider>(context,
//                                                 listen: false)
//                                             .deleteContacts(e);
//                                       },
//                                       child: const Text("Delete"),
//                                     ),
//                                   ];
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//     );
//   }
// }
//
// class AlertBox extends StatelessWidget {
//   const AlertBox({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Add Contact"),
//       content: SizedBox(
//         height: 400,
//         width: 300,
//         child: Consumer<StepperProvider>(
//           builder: (context, stepProvider, _) {
//             return Stepper(
//               currentStep: stepProvider.step,
//               controlsBuilder: (context, _) {
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           stepProvider.forwardStep(context);
//                         },
//                         child: Text(stepProvider.step == 2 ? "Save" : "Next"),
//                       ),
//                       if (stepProvider.step != 0)
//                         Container(
//                           margin: const EdgeInsets.only(left: 10),
//                           child: OutlinedButton(
//                             onPressed: stepProvider.backwardStep,
//                             child: const Text("Cancel"),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//               steps: [
//                 Step(
//                   title: const Text("Name"),
//                   content: Container(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: TextField(
//                         controller: stepProvider.nameController,
//                         decoration: const InputDecoration(
//                           hintText: "Name",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 Step(
//                   title: const Text("Contact"),
//                   content: Container(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: TextField(
//                         controller: stepProvider.contactController,
//                         decoration: const InputDecoration(
//                           hintText: "Contact",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 Step(
//                   title: const Text("Email"),
//                   content: Container(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: TextField(
//                         controller: stepProvider.emailController,
//                         decoration: const InputDecoration(
//                           hintText: "Email",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
