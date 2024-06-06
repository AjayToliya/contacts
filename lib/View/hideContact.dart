import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/hide_ContactProvider.dart';
import 'package:mycontacts/Provider/image_provider.dart';
import 'package:provider/provider.dart';

class hidePage extends StatelessWidget {
  const hidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hidden Contacts",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
      body: (Provider.of<HideContactProvider>(context).hideContacts.isEmpty)
          ? Align(
              alignment: Alignment.center,
              child: Text(
                "No Contact here",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
              ),
            )
          : Consumer<HideContactProvider>(
              builder: (context, hideContacts, _) {
                return ListView(
                  children: hideContacts.hideContacts.map((e) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, bottom: 5),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('detailPage', arguments: e);
                            },
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      // backgroundImage: FileImage(
                                      // File(Provider.of<imageProvider>(context)
                                      //     .imagePicker),
                                      // ),
                                      // replace with your image file path
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
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
                                          Provider.of<ContactProvider>(context,
                                                  listen: false)
                                              .addContacts(e);
                                          Provider.of<HideContactProvider>(
                                                  context,
                                                  listen: false)
                                              .removeContact(e);
                                        },
                                        child: Text("Unhide"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          Provider.of<HideContactProvider>(
                                                  context,
                                                  listen: false)
                                              .removeContact(e);
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            )),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
