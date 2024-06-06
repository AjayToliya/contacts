import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';

class HideContactProvider extends ChangeNotifier {
  List<Contact> hideContacts = [];

  void addContact(Contact contact) {
    hideContacts.add(contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    hideContacts.remove(contact);
    notifyListeners();
  }
}
