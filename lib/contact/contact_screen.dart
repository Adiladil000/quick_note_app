import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactWithMe extends StatefulWidget {
  const ContactWithMe({Key? key}) : super(key: key);

  @override
  State<ContactWithMe> createState() => _ContactWithMeState();
}

class _ContactWithMeState extends State<ContactWithMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: contactTitle(),
          flexibleSpace: flexibleSpaceContact(),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48.0))),
        ),
        body: ContactUs(
          logo: Image.asset(contactImage).image,
          email: emailAdress,
          companyName: companyName,
          phoneNumber: phoneNumber,
          dividerThickness: 2,
          tagLine: tagLine,
          cardColor: Colors.white,
          companyColor: Colors.teal.shade300,
          taglineColor: Colors.teal.shade100,
          textColor: Colors.teal.shade900,
        ));
  }

  String get contactImage => 'assets/png/adill.png';

  Container flexibleSpaceContact() {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(48.0)),
            gradient: LinearGradient(
                begin: Alignment.centerRight, end: Alignment.centerLeft, colors: <Color>[Colors.purple, Colors.blue])));
  }

  Text contactTitle() {
    return Text(
      'Contact',
      style: const TextStyle(fontStyle: FontStyle.italic).copyWith(fontSize: 20),
    );
  }

  String get tagLine => 'Junior Developer ';

  String get emailAdress => 'hesenovadil757@gmail.com';

  String get phoneNumber => '+994513709807';

  String get companyName => 'Həsənov Adil';
}

TextStyle italicFontStyle() => const TextStyle(fontStyle: FontStyle.italic);
