import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/sos/presentation/widgets/tipcontainer.dart';

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
    "Use well-lit and populated routes when moving around campus at night.",
    "Avoid sharing personal information or your location with strangers.",
    "Keep your mobile devices, laptops, and wallets secure at all times.",
    "Check that your vehicle is locked and valuables are hidden if you park on campus.",
    "Familiarize yourself with campus emergency exits and evacuation routes.",
    "Participate in any self-defense or safety workshops offered by the university.",
    "Always let someone know your whereabouts if going to a remote area of campus.",
    "Do not accept rides from strangers or unverified rideshare services.",
    "Keep emergency apps or safety tools installed on your phone.",
    "If confronted by a suspicious person, leave the area and contact security immediately.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0, top: 5),
              child: Center(
                child: Text(
                  "Useful security tips",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          SliverList.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Tipcontainer(
                icon: SvgPicture.asset("assets/icons/tip.svg"),
                date: null,
                content: tip,
              );
            },
          ),
          SliverToBoxAdapter(
            child: Container(height: 50, color: Color(0xFFF3F3F3)),
          ),
        ],
      ),
    );
  }
}
