import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionName extends StatelessWidget {
  final String name;
  const SectionName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
