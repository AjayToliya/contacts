import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> allContact = [];

  void addContacts(Contact contact) {
    allContact.add(contact);
    notifyListeners();
  }

  void deleteContacts(Contact contact) {
    allContact.remove(contact);
    notifyListeners();
  }

  void updateContact(Contact contact) {}
}
