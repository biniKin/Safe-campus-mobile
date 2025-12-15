import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/sos/presentation/screens/announcements_page.dart';
import 'package:safe_campus/features/sos/presentation/screens/alerts.dart';
import 'package:safe_campus/features/sos/presentation/screens/tipsPage.dart';

class Alertpage extends StatelessWidget {
  const Alertpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: Color(0xFFF3F3F3),
          automaticallyImplyLeading: false,

          title: TabBar(
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Alerts'),
              Tab(text: 'Announcements'),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Alerts(), 
            AnnouncementsPage(), 
            Tipspage(),
          ],
        ),
      ),
    );
  }
}
