import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/tipcontainer.dart';

class Tipspage extends StatelessWidget {
  Tipspage({super.key});

  final List<String> tips = [
    "Lock your doors at all times, even if you're just stepping out briefly.",
    "Never leave personal belongings unattended in libraries, cafeterias, or classrooms.",
    "Walk in groups at night, especially in poorly lit or isolated areas.",
    "Save campus security’s number in your phone for quick access in emergencies.",
    "Don’t prop open security doors in dorms or academic buildings.",
    "Always carry your student ID and show it when requested by campus personnel.",
    "Be aware of your surroundings and trust your instincts if something feels off.",
    "Report suspicious activity to campus security immediately.",
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 5),
            child: Text(
              "Useful security tips",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        SliverList.builder(
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Tipcontainer(
              content: "${index + 1}. $tip",
            );
          },
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 60,        
            color: Colors.white,
          ),
        ),

      ],
    ),
  );
}
}