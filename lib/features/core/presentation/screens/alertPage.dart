import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/historyPage.dart';
import 'package:safe_campus/features/core/presentation/screens/ongoingPage.dart';
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
          title: Text(
            "Alerts",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(
                //text: 'History',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("History"),
                    SizedBox(width: 5),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        //number of histories
                        child: Text("3", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: Expanded(
          child: TabBarView(
            children: [
              Ongoingpage(), 
              Historypage(), 
              Tipspage(),
            ],
          ),
        ),
      ),
    );
  }
}
