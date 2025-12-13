import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/announcements_page.dart';
import 'package:safe_campus/features/core/presentation/screens/alerts.dart';
import 'package:safe_campus/features/core/presentation/screens/tipsPage.dart';

class Alertpage extends StatelessWidget {
  const Alertpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          
          title: TabBar(
            labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Alerts', ),
              Tab(
                text: 'Announcements',
          
              ),
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
