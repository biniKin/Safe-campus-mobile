import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/sos/presentation/widgets/tipcontainer.dart';
// import 'package:safe_campus/features/core/presentation/screens/tipcontainer.dart';

class Tipspage extends StatelessWidget {
  Tipspage({super.key});

  final List<String> tips = [
  "Lock your doors at all times, even if you're just stepping out briefly. Many incidents happen during short absences, so always secure your room, dorm, or office whenever you leave, regardless of how quick the trip may seem.",

  "Never leave personal belongings unattended in libraries, cafeterias, or classrooms. Items like laptops, phones, backpacks, and wallets can be stolen in seconds if left alone, even in busy or familiar places.",

  "Walk in groups at night, especially in poorly lit or isolated areas. Being with others significantly reduces risk and increases visibility, making you less vulnerable to potential threats.",

  "Save campus security’s phone number in your contacts for quick access in emergencies. Having it readily available allows you to act fast during stressful situations when every second matters.",

  "Don’t prop open security doors in dorms or academic buildings. These doors are designed to control access and protect residents; keeping them open can allow unauthorized individuals to enter.",

  "Always carry your student ID and show it when requested by campus personnel. Identification helps security staff maintain a safe environment and ensures that only authorized individuals are present.",

  "Be aware of your surroundings and trust your instincts if something feels off. Avoid distractions like excessive phone use and stay alert to unusual behavior, sounds, or movements around you.",

  "Report suspicious activity to campus security immediately. Early reporting can prevent incidents and helps security respond quickly to potential threats or unsafe situations.",

  "Use well-lit and populated routes when moving around campus at night. Stick to main pathways and avoid shortcuts through dark or isolated areas whenever possible.",

  "Avoid sharing personal information or your location with strangers. Oversharing, especially on social media, can make you an easy target for scams or unwanted attention.",

  "Keep your mobile devices, laptops, and wallets secure at all times. Use strong passwords, avoid leaving valuables visible, and consider tracking apps for added protection.",

  "Check that your vehicle is locked and valuables are hidden if you park on campus. Leaving items in plain sight increases the risk of break-ins, even in monitored parking areas.",

  "Familiarize yourself with campus emergency exits and evacuation routes. Knowing where to go during emergencies such as fires or lockdowns can help you stay calm and react quickly.",

  "Participate in any self-defense or safety workshops offered by the university. These programs teach valuable skills and awareness techniques that can help you protect yourself.",

  "Always let someone know your whereabouts if going to a remote area of campus. Sharing your plans adds an extra layer of safety in case something unexpected happens.",

  "Do not accept rides from strangers or unverified rideshare services. Always use trusted transportation options to reduce the risk of unsafe situations.",

  "Keep emergency apps or safety tools installed on your phone. These tools can provide quick access to alerts, location sharing, and emergency assistance when needed.",

  "If confronted by a suspicious person, leave the area immediately and contact campus security. Prioritize your safety by creating distance and seeking help without delay."
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
          child: Container(
            height: 50,        
            color: Color(0xFFF3F3F3)
          ),
        ),

      ],
    ),
  );
}
}