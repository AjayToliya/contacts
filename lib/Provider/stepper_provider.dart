import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:provider/provider.dart';

class StepperProvider extends ChangeNotifier {
  int step = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void forwardStep(BuildContext context) {
    if (step == 2) {
      Contact contact = Contact(
        name: nameController.text,
        contact: contactController.text,
        email: emailController.text,
      );
      Provider.of<ContactProvider>(context, listen: false).addContacts(contact);
      Navigator.pop(context);
    }
    if (step < 2) {
      step++;
    }
    notifyListeners();
  }

  backwardStep() {
    if (step > 0) {
      step--;
    }
    notifyListeners();
  }
}
