import 'package:flutter/material.dart';

class Extenses extends StatefulWidget {
  const Extenses({super.key});

  @override
  State<Extenses> createState() {
    return _Extenses();
  }
}

class _Extenses extends State<Extenses> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('The Chart'),
          Text('Expenses List'),
        ],
      ),
    );
  }
}
