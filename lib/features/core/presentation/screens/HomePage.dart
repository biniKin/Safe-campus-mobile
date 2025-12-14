import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_state.dart';
import 'package:safe_campus/features/core/functions/time_formater.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_state.dart';
import 'package:safe_campus/features/core/presentation/screens/home_trusted_contact_continer.dart';
import 'package:safe_campus/features/core/presentation/screens/panic_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/sos_cubit/sos_cubit.dart';
import 'package:safe_campus/features/core/presentation/screens/sos_home_container.dart';
import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/contact_form_bottom_sheet.dart';
import 'dart:async';
import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as console show log;

class HomePage extends StatefulWidget {
  final List<Map<String, String>> initialContacts; // Accept initial contacts
  final Function(List<Map<String, String>>)
  onContactsUpdated; // Callback to update contacts

  const HomePage({
    super.key,
    required this.initialContacts,
    required this.onContactsUpdated,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationData? _currentLocation;
  // List<Map<String, String>> recentActivities = [];
  bool isSelected = false;
  // List<Map<String, String>> recentActivities = [];
  //List<Map<String, String>> contacts = [];

  // List<Map<String, String>> incidents = [
  //   {
  //     'name': 'Low visibility area',
  //     'description':
  //         'Poor lighting near the main gate\nType: general\nSeverity: medium',
  //     'type': 'incident',
  //     'timestamp': DateTime.now().subtract(Duration(hours: 2)).toString(),
  //   },
  //   {
  //     'name': 'Construction work',
  //     'description':
  //         'Ongoing construction near Block A\nType: construction\nSeverity: low',
  //     'type': 'incident',
  //     'timestamp': DateTime.now().subtract(Duration(hours: 5)).toString(),
  //   },
  // ];
  bool showAllActivities = false;

  Timer? _sosPulseTimer;

  @override
  void initState() {
    super.initState();
    console.log('The home page widget has been intiaisted ');
    //context.read<ContactListBloc>().add(FetchContactListEvent());
    // Initialize recent activities with both incidents and contacts
    // recentActivities = [
    //   ...incidents.map(
    //     (incident) => {
    //       'name': incident['name'] ?? '',
    //       'description':
    //           'Type: ${incident['description']?.split('\n')[0]}\nSeverity: ${incident['description']?.split('\n')[1]}',
    //       'type': 'incident',
    //       'timestamp': incident['timestamp'] ?? DateTime.now().toString(),
    //     },
    //   ),
    // ];
  }

  @override
  void dispose() {
    _sosPulseTimer?.cancel();
    super.dispose();
  }

  void _stopSOSMode() {
    context.read<SosCubit>().offEmergencyMode();
    _sosPulseTimer?.cancel();
  }

  void openReportIncidentSheet() async {
    final picker = ImagePicker();
    String selectedType = 'general';
    String selectedSeverity = 'medium';
    XFile? selectedMedia;
    TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7E7FB9),
                                    Color(0xFF36374E),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Icon(Icons.report, size: 70),
                            SizedBox(height: 10,),
                            Text(
                              "Report Incident",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: "Describe the incident",
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              initialValue: selectedType,

                              decoration: InputDecoration(
                                labelText: "Incident Type",
                                labelStyle: GoogleFonts.poppins(),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'general',
                                  child: Text('General'),
                                ),
                                DropdownMenuItem(
                                  value: 'crime',
                                  child: Text('Crime'),
                                ),
                                DropdownMenuItem(
                                  value: 'accident',
                                  child: Text('Accident'),
                                ),
                                DropdownMenuItem(
                                  value: 'construction',
                                  child: Text('Construction'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              initialValue: selectedSeverity,
                              decoration: InputDecoration(
                                labelText: "Severity Level",
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'low',
                                  child: Text('Low'),
                                ),
                                DropdownMenuItem(
                                  value: 'medium',
                                  child: Text('Medium'),
                                ),
                                DropdownMenuItem(
                                  value: 'high',
                                  child: Text('High'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedSeverity = value!;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: ()async{
                                final result = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedMedia = result;
                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.image),
                                        Text(selectedMedia != null ? selectedMedia?.name ?? 'File Attached' : "Attach Media"),
                                      ],
                                    ),
                                    selectedMedia != null ? Icon(Icons.done_all_rounded, color: Colors.green,) : SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.grey),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  // child: Container(
                                  //   decoration: BoxDecoration(
                                  //     gradient: const LinearGradient(
                                  //       colors: [
                                  //         Color(0xFF7E7FB9),
                                  //         Color(0xFF36374E),
                                  //       ],
                                  //       begin: Alignment.topCenter,
                                  //       end: Alignment.bottomCenter 
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //         color: Colors.grey.withOpacity(0.2),
                                  //         spreadRadius: 1,
                                  //         blurRadius: 4,
                                  //         offset: Offset(0, 2),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   child: ElevatedButton(
                                  //     onPressed: () async {
                                  //       final prefs =
                                  //           await SharedPreferences.getInstance();
                                  //       final token =
                                  //           prefs.getString('token') ?? '';
                                    
                                  //       print('The token is $token');
                                  //       // Navigator.pop(context);
                                    
                                  //       context.read<ReportBloc>().add(
                                  //          SendReportEvent(
                                  //           description:
                                  //               descriptionController.text,
                                  //           tags:
                                  //               '$selectedType, $selectedSeverity',
                                  //           image: selectedMedia?.path ?? '',
                                  //           location: {
                                  //             "type":"Point",
                                  //             'coordinates': [
                                  //               _currentLocation?.latitude.toString() ?? 0.0,
                                    
                                  //               _currentLocation?.latitude ?? 0.0
                                  //             ],
                                  //             // 'latitude':
                                  //             //     _currentLocation?.latitude
                                  //             //         .toString() ??
                                  //             //     '',
                                  //             // 'longitude':
                                  //             //     _currentLocation?.longitude
                                  //             //         .toString() ??
                                  //             //     '',
                                  //           },
                                  //           token: token,
                                  //         ),
                                  //       );
                                    
                                  //       if (state is ReportSuccess) {
                                  //         Fluttertoast.showToast(
                                  //           msg: "Incident reported successfully",
                                  //           toastLength: Toast.LENGTH_SHORT,
                                  //           gravity: ToastGravity.BOTTOM,
                                  //           timeInSecForIosWeb: 1,
                                  //           backgroundColor: Colors.green,
                                  //           textColor: Colors.white,
                                  //         );
                                  //       }
                                    
                                  //       print("${selectedMedia?.path}");
                                  //     },
                                      
                                  //     child: BlocBuilder<ReportBloc, ReportState>(
                                  //       builder: (context, state) {
                                  //         if(state is ReportLoading){
                                  //           return SizedBox(
                                  //             height: 15,
                                  //             width: 15,
                                  //             child: CircularProgressIndicator(color: Colors.black,),);
                                  //         } else if(state is ReportSuccess){
                                  //           Fluttertoast.showToast(msg: state.message);
                                  //           Navigator.pop(context);
                                  //         }
                                  //         return Text(
                                  //           "Submit",
                                  //           style: GoogleFonts.poppins(
                                  //             fontSize: 16,
                                  //             color: Colors.white,
                                  //           ),
                                  //         );
                                  //       }
                                  //     ),
                                  //   ),
                                  // ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7E7FB9),
                                          Color(0xFF36374E),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: BlocConsumer<ReportBloc, ReportState>(
                                      listener: (context, state) {
                                        if (state is ReportSuccess) {
                                          Fluttertoast.showToast(
                                            msg: state.message,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                          );
                                          Navigator.pop(context);
                                        }

                                        if (state is ReportFailed) {
                                          Fluttertoast.showToast(
                                            msg: "Report failed. Please try again later.",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading = state is ReportLoading;

                                        return ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () async {
                                                  final prefs = await SharedPreferences.getInstance();
                                                  final token = prefs.getString('token') ?? '';

                                                  context.read<ReportBloc>().add(
                                                    SendReportEvent(
                                                      description: descriptionController.text,
                                                      tags: '$selectedType, $selectedSeverity',
                                                      image: selectedMedia?.path ?? '',
                                                      location: {
                                                        "type": "Point",
                                                        "coordinates": [
                                                          _currentLocation?.latitude ?? 0.0,
                                                          _currentLocation?.longitude ?? 0.0,
                                                        ],
                                                      },
                                                      token: token,
                                                    ),
                                                  );
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            child: isLoading
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    "Submit",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ),
    );
  }

  void openShareRouteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<ContactListBloc, ContactListState>(
          builder: (context, state) {
            if (state is ContactListLoaded) {
              final contacts = state.contacts;
              // track selection per contact
              List<bool> selected = List.generate(
                contacts.length,
                (_) => false,
              );

              // Use StatefulBuilder so checkboxes update locally
              return StatefulBuilder(
                builder: (
                  BuildContext context,
                  void Function(void Function()) setState,
                ) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Share Your Location",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    selected[index] = !selected[index];
                                  });
                                },
                                leading: Checkbox(
                                  value: selected[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selected[index] = value ?? false;
                                    });
                                  },
                                ),
                                title: Text(contacts[index].name),
                                subtitle: Text(contacts[index].phoneNumber),
                              );
                            },
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF65558F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 32,
                              ),
                            ),
                            onPressed: () {
                              // Gather selected contacts
                              List<Map<String, String>> selectedContacts = [];
                              for (int i = 0; i < contacts.length; i++) {
                                if (selected[i]) {
                                  selectedContacts.add({
                                    'name': contacts[i].name,
                                    'phoneNumber': contacts[i].phoneNumber,
                                    'email': contacts[i].email,
                                  });
                                }
                              }

                              // For now, just log the selected contacts
                              console.log(
                                'Sharing location with: $selectedContacts',
                              );

                              Navigator.pop(context);
                            },
                            child: Text(
                              "Share",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  void openManageContactsSheet() async {
    await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => ContactFormBottomSheet(
            onSave: (name, phone, email) {
              console.log('Save contact button is clicked');

              context.read<ContactListBloc>().add(
                AddContactEvent(
                  contact: {'name': name, 'phoneNumber': phone, 'email': email},
                ),
              );

              Navigator.pop(context); // close the sheet
            },
          ),
    ).then((_) {
      // Bottom sheet has been closed; refresh contacts now
      //context.read<ContactListBloc>().add(FetchContactListEvent());
    });
  }

  void deleteContact(int index) {
    setState(() {
      List<Map<String, String>> updatedContacts = List.from(
        widget.initialContacts,
      );
      updatedContacts.removeAt(index);
      widget.onContactsUpdated(updatedContacts);
    });
  }

  void openDialogeBox(isEmergencyMode) {
    if (isEmergencyMode) {
      _stopSOSMode();
      return;
    }
  }

  void _showActivityDetails(Map<String, String> activity) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              activity['name'] ?? '',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activity['type'] == 'incident') ...[
                  Text(
                    'Type: ${activity['description']?.split('\n')[0].replaceAll('Type: ', '') ?? ''}',
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Severity: ${activity['description']?.split('\n')[1].replaceAll('Severity: ', '') ?? ''}',
                    style: GoogleFonts.poppins(),
                  ),
                ] else ...[
                  Text(
                    'Phone: ${activity['description']?.split('\n')[0].replaceAll('Phone: ', '') ?? ''}',
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${activity['description']?.split('\n')[1].replaceAll('Email: ', '') ?? ''}',
                    style: GoogleFonts.poppins(),
                  ),
                ],
                SizedBox(height: 16),
                Text(
                  'Reported ${formatTimestamp(activity['timestamp'] ?? '')}',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),

              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(color: Color(0xFF65558F)),
                ),
              ),
            ],
          ),
    );
  }

Widget buildRecentActivities() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Always show this
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 1,
              
              color: Colors.grey[400],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Recent Activities",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: 1,
              
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Activity list depends on state
      BlocBuilder<RecentActivityBloc, RecentActivityState>(
        builder: (context, state) {
          if (state is RecentActivitiesLoaded) {
            final activities = state.activities;
            final showCount = activities.length > 3 ? 3 : activities.length;
            final activitiesToShow = activities.take(showCount).toList();

            if (activitiesToShow.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, size: 80, color: Colors.grey,),
                    SizedBox(height: 20,),
                    Text("NO RECENT ACTIVITY", style: TextStyle(color: Colors.grey),),
                  ],
                ),
              );
            }

            return Column(
              children: [
                ...activitiesToShow.map((activity) {
                  return SosHomeContainer(
                    time: DateTime.parse(activity.time.toString()), // convert string to DateTime
                    title: "SOS Alert",
                    onDelete: (){
                      print("on sos alert history deleting ");
                      context.read<RecentActivityBloc>().add(DeleteActivityEvent(id: activity.id));
                    },
                  );
                }).toList(),

                if (activities.length > 3)
                  TextButton(
                    onPressed: () {
                      // TODO: open full activities page or sheet
                    },
                    child: const Text("See more"),
                  ),
              ],
            );
          }

          // Loading or other states
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF3F3F3),
            surfaceTintColor: Colors.transparent,
            // leading: Image.asset(
            //     'assets/images/ICON.PNG',
            //     width: 20,
            //     height: 20,
            //     fit: BoxFit.cover,
            //   ),
            title: Text(
              "SafeCampus",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            
          ),
          backgroundColor: Color(0xFFF3F3F3),
          body: SafeArea(
            child: ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Column(
                          children: [
                            // Share and Report buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7E7FB9),
                                          Color(0xFF36374E),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter 
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: openShareRouteSheet,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.share, size: 40, color: Colors.white,),
                                          SizedBox(height: 8),
                                          Text(
                                            "Share my route",
                                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7E7FB9),
                                          Color(0xFF36374E),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter 
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: openReportIncidentSheet,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.assignment, size: 40, color: Colors.white,),
                                          SizedBox(height: 8),
                                          Text(
                                            "Report incidents",
                                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Trusted Contacts Section
                            buildTrustedContacts(),

                            const SizedBox(height: 20),

                            // Recent Activities Section
                            buildRecentActivities(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocListener<SosCubit, SosState>(
                  listener: (context, state){
                    if(state.isEmergencyMode){
                      showSOSBottomSheet(context: context, onCancel: (){
                        // context.read<SosCubit>().offEmergencyMode();
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: SizedBox.shrink()
                ),
                  
                // if (state.isEmergencyMode)
                // Positioned.fill(
                //   child: Container(
                //     color: Colors.red.withOpacity(0.1),
                //     child: Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           TweenAnimationBuilder<double>(
                //             tween: Tween(begin: 1.0, end: 1.5),
                //             duration: const Duration(milliseconds: 1000),
                //             builder: (context, value, child) {
                //               return Transform.scale(
                //                 scale: value,
                //                 child: Container(
                //                   padding: const EdgeInsets.all(20),
                //                   decoration: BoxDecoration(
                //                     color: Colors.red,
                //                     shape: BoxShape.circle,
                //                   ),
                //                   child: Text(
                //                     "SOS",
                //                     style: GoogleFonts.poppins(
                //                       color: Colors.white,
                //                       fontSize: 32,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //           const SizedBox(height: 20),
                //           ElevatedButton(
                //             onPressed: _stopSOSMode,
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //             ),
                //             child: Text(
                //               "Cancel Emergency",
                //               style: GoogleFonts.poppins(
                //                 color: Colors.red,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTrustedContacts() {
    return BlocBuilder<ContactListBloc, ContactListState>(
      builder: (context, state) {
        console.log('state of the app is $state');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                    ), 
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Trusted Contacts",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(flex: 5, child: Container(decoration: BoxDecoration(color: Colors.grey[400],), height: 1,)),
                
              ],
            ),

            const SizedBox(height: 5),

            // ==============================
            //     STATE - LOADING
            // ==============================
            if (state is ContactListLoading)
              const Center(child: CircularProgressIndicator()),

            // ==============================
            //     STATE - LOADED
            // ==============================
            if (state is ContactListLoaded)
              state.contacts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.contacts.length + 1,
                    itemBuilder: (context, index) {
                      
                      if(index == state.contacts.length ){
                        return TextButton(onPressed: (){
                          // print(state.message);
                          openManageContactsSheet();
                        }, child: Text("Add more"));
                      }
                      final contact = state.contacts[index];
                      return HomeTrustedContactContiner(
                        name: contact.name,
                        onDelete: (){
                          // remove contact
                          print("on delete trusted contacts");
                          context.read<ContactListBloc>().add(DeleteContactEvent(contact.email));
                        },
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        /// Drag handle
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(width: 40), // balance spacing

                                            /// Drag handle
                                            // Container(
                                            //   height: 4,
                                            //   width: 60,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(10),
                                            //     gradient: const LinearGradient(
                                            //       colors: [
                                            //         Color(0xFF7E7FB9),
                                            //         Color(0xFF36374E),
                                            //       ],
                                            //       begin: Alignment.topCenter,
                                            //       end: Alignment.bottomCenter,
                                            //     ),
                                            //   ),
                                            // ),

                                            /// Popup menu
                                            PopupMenuButton<String>(
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 'delete') {
                                                  // _showDeleteConfirmation(context);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                                          
                                        const SizedBox(height: 20),
                                                          
                                        /// Person icon
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 99, 94, 139).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.black,
                                          ),
                                        ),
                                                          
                                        const SizedBox(height: 12),
                                                          
                                        /// Name
                                        Text(
                                          contact.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                                          
                                        const SizedBox(height: 6),
                                                          
                                        /// Email
                                        Text(
                                          contact.email,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                                          
                                        const SizedBox(height: 6),
                                                          
                                        /// Phone
                                        Text(
                                          contact.phoneNumber,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                                          
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );

                    }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),

            // ==============================
            //     STATE - ERROR
            // ==============================
            if (state is ContactListError)
              Center(
                child: Column(
                  children: [
                    Text(
                      "Low internet connect.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    IconButton(onPressed: (){
                      print(state.message);
                      openManageContactsSheet();
                    }, icon: Icon(Icons.add))
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.contact_page_outlined, size: 90, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "No contacts added yet",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7E7FB9),
                  Color(0xFF36374E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter 
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                openManageContactsSheet();
            
                console.log('Add contact button in empty state is clicked');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Add Contact",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
