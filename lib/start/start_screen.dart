import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Image.asset(
              _notePngPath,
              height: MediaQuery.of(context).size.height / 2,
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            ElevatedButton(
                onPressed: () {
                  var newRoute = MaterialPageRoute(builder: (context) => const HomeView());
                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                },
                child: const Text('Başla ')),
          ],
        ),
      ),
    );
  }

  String get _notePngPath => 'assets/png/note.png';
}
