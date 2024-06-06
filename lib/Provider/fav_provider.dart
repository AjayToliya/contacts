import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';

class favContactProvider extends ChangeNotifier {
  List<Contact> favContacts = [];

  void addContact(Contact contact) {
    favContacts.add(contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    favContacts.remove(contact);
    notifyListeners();
  }
}
