import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/fav_provider.dart';
import 'package:mycontacts/Provider/image_provider.dart';
import 'package:mycontacts/Provider/stepper_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Contact contact = ModalRoute.of(context)!.settings.arguments as Contact;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 700,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Provider.of<favContactProvider>(context,
                                        listen: false)
                                    .addContact(contact);
                              },
                              icon: Icon(
                                Icons.star_border,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final stepperProvider =
                                        Provider.of<StepperProvider>(context,
                                            listen: false);
                                    stepperProvider.nameController =
                                        TextEditingController(
                                            text: contact.name);
                                    stepperProvider.contactController =
                                        TextEditingController(
                                            text: contact.contact);
                                    stepperProvider.emailController =
                                        TextEditingController(
                                            text: contact.email);

                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      title: Text("Edit Contact"),
                                      content: Consumer<StepperProvider>(
                                        builder: (context, provider, child) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller:
                                                    provider.nameController,
                                                decoration: InputDecoration(
                                                  labelText: "Name",
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    provider.contactController,
                                                decoration: InputDecoration(
                                                  labelText: "Contact",
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    provider.emailController,
                                                decoration: InputDecoration(
                                                  labelText: "Email",
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final provider =
                                                Provider.of<StepperProvider>(
                                                    context,
                                                    listen: false);
                                            contact.name =
                                                provider.nameController.text;
                                            contact.contact =
                                                provider.contactController.text;
                                            contact.email =
                                                provider.emailController.text;

                                            Provider.of<ContactProvider>(
                                                    context,
                                                    listen: false)
                                                .updateContact(contact);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<ContactProvider>(context,
                                        listen: false)
                                    .deleteContacts(contact);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (route) => false);
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 40),
                  child: Column(
                    children: [
                      Consumer<imageProvider>(
                        builder: (context, step, _) {
                          return CircleAvatar(
                              radius: 70,
                              backgroundImage: (step.pickImagePath != null)
                                  ? FileImage(File(step.pickImagePath!))
                                  : null,
                              child: (step.pickImagePath == null)
                                  ? IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                title: Text("Pick Image"),
                                                content: Text(
                                                    "Choose Image From Gallery or Camera"),
                                                actions: [
                                                  FloatingActionButton(
                                                    mini: true,
                                                    onPressed: () async {
                                                      await Provider.of<
                                                                  imageProvider>(
                                                              context,
                                                              listen: false)
                                                          .pickPhoto();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    elevation: 3,
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                    ),
                                                  ),
                                                  FloatingActionButton(
                                                    mini: true,
                                                    onPressed: () async {
                                                      await Provider.of<
                                                                  imageProvider>(
                                                              context,
                                                              listen: false)
                                                          .pickImage();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    elevation: 3,
                                                    child: Icon(
                                                      Icons.image,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              color: Color(0xfffaf9fe),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconButton(
                          context,
                          icon: Icons.message,
                          color: Colors.blue,
                          label: "Message",
                          onTap: () async {
                            await launchUrl(
                                Uri.parse("sms:${contact.contact}"));
                          },
                        ),
                        _buildIconButton(
                          context,
                          icon: Icons.email,
                          color: Colors.red,
                          label: "Mail",
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                "mailto:${contact.email}?subject=dummy&body=this is dummy"));
                          },
                        ),
                        _buildIconButton(
                          context,
                          icon: Icons.share,
                          color: Colors.green,
                          label: "Share",
                          onTap: () {
                            ShareExtend.share(
                                "Name : ${contact.name}\nContact : ${contact.contact}",
                                "text");
                          },
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Contact Number",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse("tel:${contact.contact}"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            contact.contact,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              foregroundColor: Colors.white,
              child: Icon(icon),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
