import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontacts/Provider/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/contact_provider.dart';
import '../Provider/fav_provider.dart';

class fav extends StatelessWidget {
  const fav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Contacts",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
      body: (Provider.of<favContactProvider>(context).favContacts.isEmpty)
          ? Align(
              alignment: Alignment.center,
              child: Text(
                "No Contact here",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
              ),
            )
          : Consumer<favContactProvider>(
              builder: (context, hideContacts, _) {
                return ListView(
                  children: Provider.of<favContactProvider>(context)
                      .favContacts
                      .map((e) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, bottom: 5),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: FileImage(File(
                                          Provider.of<imageProvider>(context)
                                              .imagePicker
                                              .toString())),
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
                                  onPressed: () async {
                                    await launchUrl(
                                        Uri.parse("tel:${e.contact}"));
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
                                          Provider.of<favContactProvider>(
                                                  context,
                                                  listen: false)
                                              .removeContact(e);
                                        },
                                        child: Text("Unfav"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          Provider.of<ContactProvider>(context,
                                                  listen: false)
                                              .deleteContacts(e);
                                          Provider.of<favContactProvider>(
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
