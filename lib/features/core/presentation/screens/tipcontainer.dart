import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tipcontainer extends StatelessWidget {
  final String content;
  
  const Tipcontainer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(content, style: TextStyle(fontSize: 18),),
      ),
    );
  }
}