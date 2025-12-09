import 'package:flutter/material.dart';

class Ongoingcontainer extends StatelessWidget {
  final Image? image;
  final String name;
  final String detailes;
  const Ongoingcontainer({
    super.key,
    required this.image,
    required this.name,
    required this.detailes,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      title: Text(name),
      subtitle: Text(detailes),
      leading: Container(
        
        decoration: BoxDecoration(
          color: Color(0xFF65558F),
          shape: BoxShape.circle
        ),
        //margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(0.7),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          backgroundImage: image == null ? null : AssetImage(''),
          child: image == null ? Icon(Icons.person, size: 30,) : null,
        ),
      ),
    );
  }
}
