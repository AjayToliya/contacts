import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/hide_ContactProvider.dart';
import 'package:mycontacts/Provider/image_provider.dart';
import 'package:mycontacts/Provider/stepper_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Modal/contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];
  bool _isSearching = false;
  List<String> _alphabetList =
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = Provider.of<ContactProvider>(context, listen: false)
          .allContact
          .where((contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.contact.toLowerCase().contains(query) ||
              contact.email.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Contacts...',
                  border: InputBorder.none,
                ),
              )
            : const Text(
                "Contacts",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('fav');
            },
            icon: const Icon(Icons.star),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () async {
                    final LocalAuthentication auth = LocalAuthentication();
                    bool isAuth = await auth.authenticate(
                        localizedReason:
                            "Please authenticate to show hidden Contacts",
                        options: const AuthenticationOptions());

                    if (isAuth) {
                      Navigator.of(context).pushNamed('hidePage');
                    }
                  },
                  child: const Text("Hidden Contacts"),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertBox();
            },
          );
          Provider.of<StepperProvider>(context, listen: false)
              .nameController
              .clear();
          Provider.of<StepperProvider>(context, listen: false)
              .contactController
              .clear();
          Provider.of<StepperProvider>(context, listen: false)
              .emailController
              .clear();

          Provider.of<StepperProvider>(context, listen: false).step = 0;
        },
        child: const Icon(Icons.add),
      ),
      body: (Provider.of<ContactProvider>(context).allContact.isEmpty)
          ? Align(
              alignment: Alignment.center,
              child: Text(
                "No Contact here",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Consumer<ContactProvider>(
                    builder: (context, contactProvider, _) {
                      final contacts = _searchController.text.isEmpty
                          ? contactProvider.allContact
                          : _filteredContacts;
                      return ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 5),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed('detailPage',
                                      arguments: contact);
                                },
                                subtitle: Row(
                                  children: [
                                    Consumer<imageProvider>(
                                      builder: (context, imageProvider, _) {
                                        return CircleAvatar(
                                          radius: 30,
                                          backgroundImage: imageProvider
                                                      .pickImagePath !=
                                                  null
                                              ? FileImage(File(
                                                  imageProvider.pickImagePath!))
                                              : null,
                                          child: imageProvider.pickImagePath ==
                                                  null
                                              ? const Icon(Icons.person)
                                              : null,
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        contact.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(
                                            "tel:${contact.contact}"));
                                      },
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            onTap: () {
                                              Provider.of<HideContactProvider>(
                                                      context,
                                                      listen: false)
                                                  .addContact(contact);
                                              Provider.of<ContactProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteContacts(contact);
                                            },
                                            child: const Text("Hide"),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              Provider.of<ContactProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteContacts(contact);
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  width: 40,
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: _alphabetList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          String letter = _alphabetList[index];
                          int contactIndex = Provider.of<ContactProvider>(
                                  context,
                                  listen: false)
                              .allContact
                              .indexWhere(
                                  (contact) => contact.name.startsWith(letter));
                          if (contactIndex != -1) {
                            Scrollable.ensureVisible(
                              context,
                              duration: const Duration(milliseconds: 300),
                              alignment: 0.5,
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text(
                            _alphabetList[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class AlertBox extends StatelessWidget {
  const AlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Contact"),
      content: SizedBox(
        height: 400,
        width: 300,
        child: Consumer<StepperProvider>(
          builder: (context, stepProvider, _) {
            return Stepper(
              currentStep: stepProvider.step,
              controlsBuilder: (context, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          stepProvider.forwardStep(context);
                        },
                        child: Text(stepProvider.step == 2 ? "Save" : "Next"),
                      ),
                      if (stepProvider.step != 0)
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: OutlinedButton(
                            onPressed: stepProvider.backwardStep,
                            child: const Text("Cancel"),
                          ),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Text("Name"),
                  content: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: stepProvider.nameController,
                        decoration: const InputDecoration(
                          hintText: "Name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Step(
                  title: const Text("Contact"),
                  content: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: stepProvider.contactController,
                        decoration: const InputDecoration(
                          hintText: "Contact",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Step(
                  title: const Text("Email"),
                  content: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: stepProvider.emailController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
