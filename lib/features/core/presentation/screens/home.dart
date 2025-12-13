import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model.dart';
import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
import 'package:safe_campus/features/core/presentation/bloc/panic_alert/panic_alert_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/panic_alert/panic_alert_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/panic_alert/panic_alert_state.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/core/presentation/screens/HomePage.dart';
import 'package:safe_campus/features/core/presentation/screens/alertPage.dart';
import 'package:safe_campus/features/map_marking/presentation/page/map_page.dart';

import 'package:safe_campus/features/core/presentation/screens/panic_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/profilePage.dart';
import 'package:safe_campus/features/core/presentation/screens/sos_cubit/sos_cubit.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> contacts = []; // Lifted contacts state to Home

  final List<Widget> pages = []; // Will initialize in initState

  @override
  void initState() {
    super.initState();
    // Initialize pages with contacts
    pages.addAll([
      HomePage(
        onContactsUpdated: (updatedContacts) {
          setState(() {
            contacts = updatedContacts;
          });
        },
        initialContacts: contacts,
      ),
      MapPage(
        /*  contacts: contacts,
        onContactsUpdated: (updatedContacts) {
          setState(() {
            contacts = updatedContacts;
          });
        },*/
      ), // Added onContactsUpdated
      Alertpage(),
      Profilepage(),
    ]);
  }

  
  void showSOSActivity(){
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.cancel_outlined)),
              ),
              Icon(Icons.check_circle, color: Colors.red, size: 60),

              SizedBox(height: 15),

              Text(
                "Emergency Request Sent",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Your emergency alert has been sent.\n"
                "Campus security has been notified and is on the way.\n\n"
                "You will receive a notification with the responder details shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      context.read<PanicAlertBloc>().add(CancelPanicAlert());
                      context.read<SosCubit>().offEmergencyMode();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      "Cancel SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      context.read<SosCubit>().offEmergencyMode();
                      context.read<PanicAlertBloc>().add(CancelPanicAlert());
                      context.read<RecentActivityBloc>().add(
                        SaveActivityEvent(
                          activity: ActivityModel(
                            id: Uuid().v4(), 
                            time: DateTime.now(),
                          ),
                        ),
                      );
                      
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: "Request solved.");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      "Mark as Solved",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }


  void openDialogeBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Confirm your request",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            content: SizedBox(
              height: 340,
              child: Column(
                children: [
                  Image.asset('assets/images/alert1.png'),
                  const SizedBox(height: 10),
                  Text(
                    "The alert will be sent to security personnel and trusted contacts with your location and personal information. Make sure you made the right request before sending alert!",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // emit cancel state
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                   //Navigator.of(context).pop();
                  // developer.log('SOS button pressed');

                  context.read<PanicAlertBloc>().add(TriggerPanicAlert());

                  // _startSOSMode();
                  // Notify trusted contacts and security
                  // Fluttertoast.showToast(msg: 'Emergency alert sent to trusted contacts and security personnel!', backgroundColor: Colors.red);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: BlocListener<PanicAlertBloc, PanicAlertState> (
                  listener: (context, state) {
                    if (state is PanicSuccess) {
                      Navigator.of(context).pop(); // close dialog
                      showSOSBottomSheet(context: context, onCancel: (){Navigator.of(context).pop();});
                      _startSOSMode();             // turn SOS ON
                    }
                  },
                  child: BlocBuilder<PanicAlertBloc, PanicAlertState>(
                    builder: (context,state) {
                      if(state is PanicLoading){
                        return SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(color: Colors.black,)
                        );
                      } 
                      return Text(
                        "Send Alert",
                        style: GoogleFonts.poppins(color: Colors.white),
                      );
                    }
                  )
                  
                ),
              ),
            ],
          ),
    );
  }

  Timer? _sosPulseTimer;

  void _startSOSMode() {
    context.read<SosCubit>().onEmergencyMode();
    // _sosPulseTimer = Timer.periodic(const Duration(milliseconds: 1000), (
    //   timer,
    // ) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(    
        builder: (context, selectedIndex) {
          return BlocBuilder<SosCubit, SosState>(
            builder: (context, state) {
              return Scaffold(
                
                body: pages[selectedIndex],
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: state.isEmergencyMode ? showSOSActivity : openDialogeBox,
                  backgroundColor: state.isEmergencyMode ? Colors.redAccent : Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Text("SOS"),
                ),
                bottomNavigationBar: BottomAppBar(
                  notchMargin: 5,
                  color: const Color.fromARGB(255, 223, 222, 236),
                  height: 80,
                  shape: const CircularNotchedRectangle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      navItem(
                        context,
                        icon: Icons.home,
                        label: "Home",
                        index: 0,
                        selected: selectedIndex,
                      ),
                      navItem(
                        context,
                        icon: Icons.map,
                        label: "Map",
                        index: 1,
                        selected: selectedIndex,
                      ),
                      const SizedBox(width: 40),
                      navItem(
                        context,
                        icon: Icons.notifications,
                        label: "Alerts",
                        index: 2,
                        selected: selectedIndex,
                      ),
                      navItem(
                        context,
                        icon: Icons.person,
                        label: "Profile",
                        index: 3,
                        selected: selectedIndex,
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }
    
    );
  }
}


Widget navItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required int index,
  required int selected,
}) {
  final isSelected = selected == index;
  final color =
      isSelected
          ? const Color(0xFF65558F)
          : const Color.fromARGB(255, 124, 124, 124);

  return InkWell(
    onTap: () => context.read<NavigationCubit>().updateIndex(index),
    child: Container(
      width: 60,
      height: 80,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    ),
  );
}
