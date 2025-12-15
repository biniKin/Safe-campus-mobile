// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:location/location.dart';
// import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_bloc.dart';
// import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_event.dart';
// import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_state.dart';
// import 'package:safe_campus/features/core/functions/time_formater.dart';
// import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
// import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
// import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_state.dart';
// import 'package:safe_campus/features/core/presentation/screens/home_trusted_contact_continer.dart';
// import 'package:safe_campus/features/core/presentation/screens/panic_bottom_sheet.dart';
// import 'package:safe_campus/features/core/presentation/screens/sos_cubit/sos_cubit.dart';
// import 'package:safe_campus/features/core/presentation/screens/sos_history_page.dart';
// import 'package:safe_campus/features/core/presentation/screens/sos_home_container.dart';
// import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'components/contact_form_bottom_sheet.dart';
// import 'dart:async';
// import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:developer' as console show log;

// class HomePage extends StatefulWidget {
//   //final List<Map<String, String>> initialContacts; // Accept initial contacts
//   //final Function(List<Map<String, String>>)
//   //onContactsUpdated; // Callback to update contacts

//   const HomePage({
//     super.key,
//     //required this.initialContacts,
//     //required this.onContactsUpdated,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   LocationData? _currentLocation;
//   // List<Map<String, String>> recentActivities = [];
//   bool isSelected = false;
//   // List<Map<String, String>> recentActivities = [];
//   //List<Map<String, String>> contacts = [];

//   // List<Map<String, String>> incidents = [
//   //   {
//   //     'name': 'Low visibility area',
//   //     'description':
//   //         'Poor lighting near the main gate\nType: general\nSeverity: medium',
//   //     'type': 'incident',
//   //     'timestamp': DateTime.now().subtract(Duration(hours: 2)).toString(),
//   //   },
//   //   {
//   //     'name': 'Construction work',
//   //     'description':
//   //         'Ongoing construction near Block A\nType: construction\nSeverity: low',
//   //     'type': 'incident',
//   //     'timestamp': DateTime.now().subtract(Duration(hours: 5)).toString(),
//   //   },
//   // ];
//   bool showAllActivities = false;

//   Timer? _sosPulseTimer;

//   @override
//   void initState() {
//     super.initState();
//     console.log('The home page widget has been intiaisted ');
//     //context.read<ContactListBloc>().add(FetchContactListEvent());
//     // Initialize recent activities with both incidents and contacts
//     // recentActivities = [
//     //   ...incidents.map(
//     //     (incident) => {
//     //       'name': incident['name'] ?? '',
//     //       'description':
//     //           'Type: ${incident['description']?.split('\n')[0]}\nSeverity: ${incident['description']?.split('\n')[1]}',
//     //       'type': 'incident',
//     //       'timestamp': incident['timestamp'] ?? DateTime.now().toString(),
//     //     },
//     //   ),
//     // ];
//   }

//   @override
//   void dispose() {
//     _sosPulseTimer?.cancel();
//     super.dispose();
//   }

//   void _stopSOSMode() {
//     context.read<SosCubit>().offEmergencyMode();
//     _sosPulseTimer?.cancel();
//   }

//   void openReportIncidentSheet() async {
//     final picker = ImagePicker();
//     String selectedType = 'general';
//     String selectedSeverity = 'medium';
//     XFile? selectedMedia;
//     TextEditingController descriptionController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder:
//           (context) => StatefulBuilder(
//             builder:
//                 (context, setState) => Padding(
//                   padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom,
//                     left: 16,
//                     right: 16,
//                     top: 16,
//                   ),
//                   child: BlocBuilder<ReportBloc, ReportState>(
//                     builder: (context, state) {
//                       return SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               height: 4,
//                               width: 60,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFF7E7FB9),
//                                     Color(0xFF36374E),
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20,),
//                             Icon(Icons.report, size: 70),
//                             SizedBox(height: 10,),
//                             Text(
//                               "Report Incident",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             TextField(
//                               controller: descriptionController,
//                               decoration: InputDecoration(
//                                 labelText: "Describe the incident",
//                                 labelStyle: GoogleFonts.poppins(),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               maxLines: 3,
//                             ),
//                             SizedBox(height: 16),
//                             DropdownButtonFormField<String>(
//                               initialValue: selectedType,

//                               decoration: InputDecoration(
//                                 labelText: "Incident Type",
//                                 labelStyle: GoogleFonts.poppins(),

//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'general',
//                                   child: Text('General'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'crime',
//                                   child: Text('Crime'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'accident',
//                                   child: Text('Accident'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'construction',
//                                   child: Text('Construction'),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedType = value!;
//                                 });
//                               },
//                             ),
//                             SizedBox(height: 16),
//                             DropdownButtonFormField<String>(
//                               initialValue: selectedSeverity,
//                               decoration: InputDecoration(
//                                 labelText: "Severity Level",
//                                 labelStyle: GoogleFonts.poppins(),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'low',
//                                   child: Text('Low'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'medium',
//                                   child: Text('Medium'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'high',
//                                   child: Text('High'),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedSeverity = value!;
//                                 });
//                               },
//                             ),
//                             SizedBox(height: 16),
//                             GestureDetector(
//                               onTap: ()async{
//                                 final result = await picker.pickImage(
//                                   source: ImageSource.gallery,
//                                 );
//                                 if (result != null) {
//                                   setState(() {
//                                     selectedMedia = result;
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 height: 50,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                   border: Border.all(
//                                     color: Colors.black,
//                                     width: 0.5
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 alignment: Alignment.centerLeft,
//                                 padding: EdgeInsets.only(left: 10, right: 10),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(Icons.image),
//                                         Text(selectedMedia != null ? selectedMedia?.name ?? 'File Attached' : "Attach Media"),
//                                       ],
//                                     ),
//                                     selectedMedia != null ? Icon(Icons.done_all_rounded, color: Colors.green,) : SizedBox.shrink()
//                                   ],
//                                 ),
//                               ),
//                             ),
                            
//                             SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: OutlinedButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     style: OutlinedButton.styleFrom(
//                                       side: BorderSide(color: Colors.grey),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 15,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "Cancel",
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   // child: Container(
//                                   //   decoration: BoxDecoration(
//                                   //     gradient: const LinearGradient(
//                                   //       colors: [
//                                   //         Color(0xFF7E7FB9),
//                                   //         Color(0xFF36374E),
//                                   //       ],
//                                   //       begin: Alignment.topCenter,
//                                   //       end: Alignment.bottomCenter 
//                                   //     ),
//                                   //     borderRadius: BorderRadius.circular(10),
//                                   //     boxShadow: [
//                                   //       BoxShadow(
//                                   //         color: Colors.grey.withOpacity(0.2),
//                                   //         spreadRadius: 1,
//                                   //         blurRadius: 4,
//                                   //         offset: Offset(0, 2),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   //   child: ElevatedButton(
//                                   //     onPressed: () async {
//                                   //       final prefs =
//                                   //           await SharedPreferences.getInstance();
//                                   //       final token =
//                                   //           prefs.getString('token') ?? '';
                                    
//                                   //       print('The token is $token');
//                                   //       // Navigator.pop(context);
                                    
//                                   //       context.read<ReportBloc>().add(
//                                   //          SendReportEvent(
//                                   //           description:
//                                   //               descriptionController.text,
//                                   //           tags:
//                                   //               '$selectedType, $selectedSeverity',
//                                   //           image: selectedMedia?.path ?? '',
//                                   //           location: {
//                                   //             "type":"Point",
//                                   //             'coordinates': [
//                                   //               _currentLocation?.latitude.toString() ?? 0.0,
                                    
//                                   //               _currentLocation?.latitude ?? 0.0
//                                   //             ],
//                                   //             // 'latitude':
//                                   //             //     _currentLocation?.latitude
//                                   //             //         .toString() ??
//                                   //             //     '',
//                                   //             // 'longitude':
//                                   //             //     _currentLocation?.longitude
//                                   //             //         .toString() ??
//                                   //             //     '',
//                                   //           },
//                                   //           token: token,
//                                   //         ),
//                                   //       );
                                    
//                                   //       if (state is ReportSuccess) {
//                                   //         Fluttertoast.showToast(
//                                   //           msg: "Incident reported successfully",
//                                   //           toastLength: Toast.LENGTH_SHORT,
//                                   //           gravity: ToastGravity.BOTTOM,
//                                   //           timeInSecForIosWeb: 1,
//                                   //           backgroundColor: Colors.green,
//                                   //           textColor: Colors.white,
//                                   //         );
//                                   //       }
                                    
//                                   //       print("${selectedMedia?.path}");
//                                   //     },
                                      
//                                   //     child: BlocBuilder<ReportBloc, ReportState>(
//                                   //       builder: (context, state) {
//                                   //         if(state is ReportLoading){
//                                   //           return SizedBox(
//                                   //             height: 15,
//                                   //             width: 15,
//                                   //             child: CircularProgressIndicator(color: Colors.black,),);
//                                   //         } else if(state is ReportSuccess){
//                                   //           Fluttertoast.showToast(msg: state.message);
//                                   //           Navigator.pop(context);
//                                   //         }
//                                   //         return Text(
//                                   //           "Submit",
//                                   //           style: GoogleFonts.poppins(
//                                   //             fontSize: 16,
//                                   //             color: Colors.white,
//                                   //           ),
//                                   //         );
//                                   //       }
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           Color(0xFF7E7FB9),
//                                           Color(0xFF36374E),
//                                         ],
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.2),
//                                           spreadRadius: 1,
//                                           blurRadius: 4,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: BlocConsumer<ReportBloc, ReportState>(
//                                       listener: (context, state) {
//                                         if (state is ReportSuccess) {
//                                           Fluttertoast.showToast(
//                                             msg: state.message,
//                                             backgroundColor: Colors.green,
//                                             textColor: Colors.white,
//                                           );
//                                           Navigator.pop(context);
//                                         }

//                                         if (state is ReportFailed) {
//                                           Fluttertoast.showToast(
//                                             msg: "Report failed. Please try again later.",
//                                             backgroundColor: Colors.red,
//                                             textColor: Colors.white,
//                                           );
//                                         }
//                                       },
//                                       builder: (context, state) {
//                                         final isLoading = state is ReportLoading;

//                                         return ElevatedButton(
//                                           onPressed: isLoading
//                                               ? null
//                                               : () async {
//                                                   final prefs = await SharedPreferences.getInstance();
//                                                   final token = prefs.getString('token') ?? '';

//                                                   context.read<ReportBloc>().add(
//                                                     SendReportEvent(
//                                                       description: descriptionController.text,
//                                                       tags: '$selectedType, $selectedSeverity',
//                                                       image: selectedMedia?.path ?? '',
//                                                       location: {
//                                                         "type": "Point",
//                                                         "coordinates": [
//                                                           _currentLocation?.latitude ?? 0.0,
//                                                           _currentLocation?.longitude ?? 0.0,
//                                                         ],
//                                                       },
//                                                       token: token,
//                                                     ),
//                                                   );
//                                                 },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 14),
//                                             child: isLoading
//                                                 ? const SizedBox(
//                                                     height: 18,
//                                                     width: 18,
//                                                     child: CircularProgressIndicator(
//                                                       strokeWidth: 2,
//                                                       color: Colors.white,
//                                                     ),
//                                                   )
//                                                 : Text(
//                                                     "Submit",
//                                                     style: GoogleFonts.poppins(
//                                                       fontSize: 16,
//                                                       color: Colors.white,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                   ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),

//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           ),
//     );
//   }

//   void openShareRouteSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return BlocBuilder<ContactListBloc, ContactListState>(
//           builder: (context, state) {
//             if (state is ContactListLoaded) {
//               final contacts = state.contacts;

//               if (contacts.isEmpty) {
//               return Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(bottom: 16),
//                       constraints: BoxConstraints(
//                         maxHeight: MediaQuery.of(context).size.height * 0.6,
//                       ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image(image: AssetImage("assets/images/shareRoute.png")),
//                       Text(
//                         "Share Your Location",
//                         style: GoogleFonts.poppins(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // const SizedBox(height: 24),
//                       // const Icon(
//                       //   Icons.person_off_outlined,
//                       //   size: 48,
//                       //   color: Colors.grey,
//                       // ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "No trusted contact added",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               );
//             }

//               // track selection per contact
//               List<bool> selected = List.generate(
//                 contacts.length,
//                 (_) => false,
//               );

//               // Use StatefulBuilder so checkboxes update locally
//               return StatefulBuilder(
//                 builder: (
//                   BuildContext context,
//                   void Function(void Function()) setState,
//                 ) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       constraints: BoxConstraints(
//                         maxHeight: MediaQuery.of(context).size.height * 0.6,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // image
//                           Image(image: AssetImage("assets/images/shareRoute.png")),
//                           //SvgPicture.asset("assets/icons/shareRoute.svg"),
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Text(
//                               "Share Your Location",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: contacts.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   onTap: () {
//                                     setState(() {
//                                       selected[index] = !selected[index];
//                                     });
//                                   },
//                                   leading: Container( // coolo
//                                     padding: const EdgeInsets.all(15),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: const Color.fromARGB(255, 99, 94, 139).withOpacity(0.2),
//                                     ),
//                                     child: Icon(Icons.person, size: 25,),
//                                   ),
//                                   trailing: Transform.scale(
//                                     scale: 1.3,
//                                     child: Checkbox(
//                                       shape: CircleBorder(),
//                                       side: BorderSide(width: 2,color: Colors.grey[600]!),
//                                       value: selected[index],
//                                       onChanged: (value) {
//                                         setState(() {
//                                           selected[index] = value ?? false;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   title: Text(contacts[index].name, style: TextStyle(fontWeight: FontWeight.bold),),
//                                   subtitle: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(contacts[index].phoneNumber, style: TextStyle( color: Colors.grey[600]),),
//                                       Text(contacts[index].email, style: TextStyle( color: Colors.grey[600])),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 20,),
                    
//                           Container(
                            
//                             width: double.infinity, 
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Color(0xFF7E7FB9),
//                                   Color(0xFF36374E),
//                                 ],
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                               ),
//                             ),
                    
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: 15,
//                                   horizontal: 32,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 // Gather selected contacts
//                                 List<Map<String, String>> selectedContacts = [];
//                                 for (int i = 0; i < contacts.length; i++) {
//                                   if (selected[i]) {
//                                     selectedContacts.add({
//                                       'name': contacts[i].name,
//                                       'phoneNumber': contacts[i].phoneNumber,
//                                       'email': contacts[i].email,
//                                     });
//                                   }
//                                 }
                    
//                                 // For now, just log the selected contacts
//                                 console.log(
//                                   'Sharing location with: $selectedContacts',
//                                 );
                    
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "Share Location",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
                          
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         );
//       },
//     );
//   }

//   void openManageContactsSheet() async {
//     await showModalBottomSheet<Map<String, String>>(
//       context: context,
//       isScrollControlled: true,
//       builder:
//           (context) => ContactFormBottomSheet(
//             onSave: (name, phone, email) {
//               console.log('Save contact button is clicked');

//               context.read<ContactListBloc>().add(
//                 AddContactEvent(
//                   contact: {'name': name, 'phoneNumber': phone, 'email': email},
//                 ),
//               );

//               Navigator.pop(context); // close the sheet
//             },
//           ),
//     ).then((_) {
//       // Bottom sheet has been closed; refresh contacts now
//       //context.read<ContactListBloc>().add(FetchContactListEvent());
//     });
//   }

//   // void deleteContact(int index) {
//   //   setState(() {
//   //     List<Map<String, String>> updatedContacts = List.from(
//   //       widget.initialContacts,
//   //     );
//   //     updatedContacts.removeAt(index);
//   //     widget.onContactsUpdated(updatedContacts);
//   //   });
//   // }

//   void openDialogeBox(isEmergencyMode) {
//     if (isEmergencyMode) {
//       _stopSOSMode();
//       return;
//     }
//   }

//   void _showActivityDetails(Map<String, String> activity) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text(
//               activity['name'] ?? '',
//               style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (activity['type'] == 'incident') ...[
//                   Text(
//                     'Type: ${activity['description']?.split('\n')[0].replaceAll('Type: ', '') ?? ''}',
//                     style: GoogleFonts.poppins(),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Severity: ${activity['description']?.split('\n')[1].replaceAll('Severity: ', '') ?? ''}',
//                     style: GoogleFonts.poppins(),
//                   ),
//                 ] else ...[
//                   Text(
//                     'Phone: ${activity['description']?.split('\n')[0].replaceAll('Phone: ', '') ?? ''}',
//                     style: GoogleFonts.poppins(),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Email: ${activity['description']?.split('\n')[1].replaceAll('Email: ', '') ?? ''}',
//                     style: GoogleFonts.poppins(),
//                   ),
//                 ],
//                 SizedBox(height: 16),
//                 Text(
//                   'Reported ${formatTimestamp(activity['timestamp'] ?? '')}',
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey[600],
//                     fontSize: 12,
//                   ),
//                 ),

//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   'Close',
//                   style: GoogleFonts.poppins(color: Color(0xFF65558F)),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

// Widget buildRecentActivities() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Always show this
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Container(
//               height: 1,
              
//               color: Colors.grey[300],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Recent Activities",
//               style: GoogleFonts.poppins(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 9,
//             child: Container(
//               height: 1,
              
//               color: Colors.grey[300],
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 16),

//       // Activity list depends on state
//       BlocBuilder<RecentActivityBloc, RecentActivityState>(
//         builder: (context, state) {
//           if (state is RecentActivitiesLoaded) {
//             final activities = state.activities;
//             final showCount = activities.length > 3 ? 3 : activities.length;
//             final activitiesToShow = activities.take(showCount).toList();

//             if (activitiesToShow.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.hourglass_empty, size: 80, color: Colors.grey,),
//                     SizedBox(height: 20,),
//                     Text("NO RECENT ACTIVITY", style: TextStyle(color: Colors.grey),),
//                   ],
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 ...activitiesToShow.map((activity) {
//                   return SosHomeContainer(
//                     time: DateTime.parse(activity.time.toString()), // convert string to DateTime
//                     title: "SOS Alert",
//                     onDelete: (){
//                       print("on sos alert history deleting ");
//                       context.read<RecentActivityBloc>().add(DeleteActivityEvent(id: activity.id));
//                     },
//                   );
//                 }).toList(),

//                 if (activities.length > 3)
//                   TextButton(
//                     onPressed: () {
//                       // TODO: open full activities page or sheet
//                       Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SosHistoryPage()));
//                     },
//                     child: const Text("See more"),
//                   ),
//               ],
//             );
//           }

//           // Loading or other states
//           return const SizedBox.shrink();
//         },
//       ),
//     ],
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SosCubit, SosState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xFFF3F3F3),
//             surfaceTintColor: Colors.transparent,
//             // leading: Image.asset(
//             //     'assets/images/ICON.PNG',
//             //     width: 20,
//             //     height: 20,
//             //     fit: BoxFit.cover,
//             //   ),
//             title: Text(
//               "SafeCampus",
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

            
//           ),
//           backgroundColor: Color(0xFFF3F3F3),
//           body: SafeArea(
//             child: ListView(
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       SingleChildScrollView(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
//                         child: Column(
//                           children: [
//                             // Share and Report buttons
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           Color(0xFF7E7FB9),
//                                           Color(0xFF36374E),
//                                         ],
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter 
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 5,
//                                           offset: Offset(2, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: InkWell(
//                                       onTap: openShareRouteSheet,
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           Icon(Icons.share, size: 40, color: Colors.white,),
//                                           SizedBox(height: 8),
//                                           Text(
//                                             "Share my route",
//                                             style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 20),
//                                 Expanded(
//                                   child: Container(
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           Color(0xFF7E7FB9),
//                                           Color(0xFF36374E),
//                                         ],
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter 
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 5,
//                                           offset: Offset(2, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: InkWell(
//                                       onTap: openReportIncidentSheet,
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           Icon(Icons.assignment, size: 40, color: Colors.white,),
//                                           SizedBox(height: 8),
//                                           Text(
//                                             "Report incidents",
//                                             style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),

//                             // Trusted Contacts Section
//                             buildTrustedContacts(),

//                             const SizedBox(height: 20),

//                             // Recent Activities Section
//                             buildRecentActivities(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 BlocListener<SosCubit, SosState>(
//                   listener: (context, state){
//                     if(state.isEmergencyMode){
//                       showSOSBottomSheet(context: context, onCancel: (){
//                         // context.read<SosCubit>().offEmergencyMode();
//                         Navigator.pop(context);
//                       });
//                     }
//                   },
//                   child: SizedBox.shrink()
//                 ),
                  
//                 // if (state.isEmergencyMode)
//                 // Positioned.fill(
//                 //   child: Container(
//                 //     color: Colors.red.withOpacity(0.1),
//                 //     child: Center(
//                 //       child: Column(
//                 //         mainAxisAlignment: MainAxisAlignment.center,
//                 //         children: [
//                 //           TweenAnimationBuilder<double>(
//                 //             tween: Tween(begin: 1.0, end: 1.5),
//                 //             duration: const Duration(milliseconds: 1000),
//                 //             builder: (context, value, child) {
//                 //               return Transform.scale(
//                 //                 scale: value,
//                 //                 child: Container(
//                 //                   padding: const EdgeInsets.all(20),
//                 //                   decoration: BoxDecoration(
//                 //                     color: Colors.red,
//                 //                     shape: BoxShape.circle,
//                 //                   ),
//                 //                   child: Text(
//                 //                     "SOS",
//                 //                     style: GoogleFonts.poppins(
//                 //                       color: Colors.white,
//                 //                       fontSize: 32,
//                 //                       fontWeight: FontWeight.bold,
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               );
//                 //             },
//                 //           ),
//                 //           const SizedBox(height: 20),
//                 //           ElevatedButton(
//                 //             onPressed: _stopSOSMode,
//                 //             style: ElevatedButton.styleFrom(
//                 //               backgroundColor: Colors.white,
//                 //               shape: RoundedRectangleBorder(
//                 //                 borderRadius: BorderRadius.circular(10),
//                 //               ),
//                 //             ),
//                 //             child: Text(
//                 //               "Cancel Emergency",
//                 //               style: GoogleFonts.poppins(
//                 //                 color: Colors.red,
//                 //                 fontWeight: FontWeight.bold,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildTrustedContacts() {
//     return BlocBuilder<ContactListBloc, ContactListState>(
//       builder: (context, state) {
//         console.log('state of the app is $state');

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // HEADER
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                     ), 
//                     height: 1,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Trusted Contacts",
//                     style: GoogleFonts.poppins(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(flex: 8, child: Container(decoration: BoxDecoration(color: Colors.grey[300],), height: 1,)),
                
//               ],
//             ),

//             const SizedBox(height: 5),

//             if (state is ContactListLoading)
//               const Center(child: CircularProgressIndicator()),

//             if (state is ContactListLoaded)
//               state.contacts.isEmpty
//                   ? _buildEmptyState()
//                   : GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: state.contacts.length + 1,
                    
//                     itemBuilder: (context, index) {
                      
//                       if(index == state.contacts.length ){
//                         return TextButton(onPressed: (){
//                           // print(state.message);
//                           openManageContactsSheet();
//                         }, child: Text("Add more"));
//                       }
//                       final contact = state.contacts[index];
//                       return HomeTrustedContactContiner(
//                         name: contact.name,
//                         onDelete: (){
//                           // remove contact
//                           print("on delete trusted contacts");
//                           context.read<ContactListBloc>().add(DeleteContactEvent(contact.email));
//                         },
//                         onTap: () {
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                             ),
//                             builder: (context) {
//                               return SafeArea(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(20),
//                                   child: SizedBox(
//                                     width: double.infinity,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         /// Drag handle
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const SizedBox(width: 40), // balance spacing

                                            

//                                             /// Popup menu
//                                             PopupMenuButton<String>(
//                                               icon: const Icon(Icons.more_vert),
//                                               onSelected: (value) {
//                                                 if (value == 'delete') {
//                                                   // _showDeleteConfirmation(context);
//                                                 }
//                                               },
//                                               itemBuilder: (context) => [
//                                                 const PopupMenuItem<String>(
//                                                   value: 'delete',
//                                                   child: Row(
//                                                     children: [
//                                                       Icon(Icons.delete, color: Colors.red),
//                                                       SizedBox(width: 8),
//                                                       Text(
//                                                         'Delete',
//                                                         style: TextStyle(color: Colors.red),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),

                                                          
//                                         const SizedBox(height: 20),
                                                          
//                                         /// Person icon
//                                         Container(
//                                           padding: const EdgeInsets.all(16),
//                                           decoration: BoxDecoration(
//                                             color: const Color.fromARGB(255, 99, 94, 139).withOpacity(0.2),
//                                             borderRadius: BorderRadius.circular(10)
//                                           ),
//                                           child: const Icon(
//                                             Icons.person,
//                                             size: 40,
//                                             color: Colors.black,
//                                           ),
//                                         ),
                                                          
//                                         const SizedBox(height: 12),
                                                          
//                                         /// Name
//                                         Text(
//                                           contact.name,
//                                           style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
                                                          
//                                         const SizedBox(height: 6),
                                                          
//                                         /// Email
//                                         Text(
//                                           contact.email,
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
                                                          
//                                         const SizedBox(height: 6),
                                                          
//                                         /// Phone
//                                         Text(
//                                           contact.phoneNumber,
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
                                                          
//                                         const SizedBox(height: 20),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );

//                     }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//                   ),

           
//             if (state is ContactListError)
//               Center(
//                 child: Column(
//                   children: [
                    
//                     _buildEmptyState()
//                   ],
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         children: [
//           const Icon(Icons.contact_page_outlined, size: 90, color: Colors.grey),
//           const SizedBox(height: 10),
//           Text(
//             "No contacts added yet",
//             style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [
//                   Color(0xFF7E7FB9),
//                   Color(0xFF36374E),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter 
//               ),
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 5,
//                   offset: Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               onPressed: () {
//                 openManageContactsSheet();
            
//                 console.log('Add contact button in empty state is clicked');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 "Add Contact",
//                 style: GoogleFonts.poppins(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:safe_campus/features/core/functions/time_ago.dart';
import 'package:safe_campus/features/core/presentation/screens/alertPage.dart';
import 'package:safe_campus/features/core/presentation/screens/home_trusted_contact_continer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/contacts_bloc/contact_list_state.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_state.dart';
import 'package:safe_campus/features/core/presentation/screens/panic_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/sos_cubit/sos_cubit.dart';
import 'package:safe_campus/features/core/presentation/screens/sos_history_page.dart';
import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';

import 'components/contact_form_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends State<HomePage> {
  LocationData? _currentLocation;
  Timer? _sosPulseTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    log('ModernHomePage initialized');
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

  // Updated modern report incident sheet
  void openReportIncidentSheet() async {
    final picker = ImagePicker();
    String selectedType = 'general';
    String selectedSeverity = 'medium';
    XFile? selectedMedia;
    TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Report Incident",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF65558F),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Help keep campus safe by reporting incidents",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Description
                            _buildModernTextField(
                              controller: descriptionController,
                              label: "Describe the incident",
                              hint: "Provide details about what happened...",
                              maxLines: 3,
                              icon: Icons.description_outlined,
                            ),
                            const SizedBox(height: 20),

                            // Incident Type
                            _buildModernDropdown(
                              value: selectedType,
                              items: const [
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
                              label: "Incident Type",
                              icon: Icons.category_outlined,
                              onChanged: (value) {
                                setState(() => selectedType = value!);
                              },
                            ),
                            const SizedBox(height: 20),

                            // Severity Level
                            _buildModernDropdown(
                              value: selectedSeverity,
                              items: const [
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
                              label: "Severity Level",
                              icon: Icons.warning_amber_outlined,
                              onChanged: (value) {
                                setState(() => selectedSeverity = value!);
                              },
                            ),
                            const SizedBox(height: 20),

                            // Media Attachment
                            _buildMediaAttachment(
                              selectedMedia: selectedMedia,
                              onTap: () async {
                                final result = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (result != null) {
                                  setState(() => selectedMedia = result);
                                }
                              },
                            ),
                            const SizedBox(height: 32),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _buildModernButton(
                                    text: "Cancel",
                                    type: ButtonType.outlined,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
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
                                      return _buildModernButton(
                                        text: "Submit Report",
                                        type: ButtonType.filled,
                                        isLoading: isLoading,
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
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Updated modern share route sheet
  void openShareRouteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocBuilder<ContactListBloc, ContactListState>(
          builder: (context, state) {
            if (state is ContactListLoaded) {
              final contacts = state.contacts;

              if (contacts.isEmpty) {
                return _buildEmptyContactsSheet();
              }

              // Track selection per contact
              List<bool> selected = List.generate(contacts.length, (_) => false);

              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Share Location",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF65558F),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close_rounded),
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Select contacts to share your real-time location",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Contact List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shrinkWrap: true,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return _buildContactListItem(
                                contact: contact,
                                isSelected: selected[index],
                                onTap: () {
                                  setState(() => selected[index] = !selected[index]);
                                },
                              );
                            },
                          ),
                        ),

                        // Share Button
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildModernButton(
                            text: "Share Location",
                            type: ButtonType.filled,
                            icon: Icons.share_outlined,
                            onPressed: () {
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
                              log('Sharing location with: $selectedContacts');
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  // Widget Builders
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                isExpanded: true,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaAttachment({
    required XFile? selectedMedia,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attach Media",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedMedia != null ? Colors.green : Colors.grey.shade300,
                width: selectedMedia != null ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: selectedMedia != null ? Colors.green : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedMedia?.name ?? "Tap to add photo/video",
                      style: GoogleFonts.poppins(
                        color: selectedMedia != null ? Colors.green : Colors.grey.shade600,
                        fontWeight: selectedMedia != null ? FontWeight.w500 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selectedMedia != null)
                    const Icon(Icons.check_circle_rounded, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernButton({
    required String text,
    required ButtonType type,
    bool isLoading = false,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    final isFilled = type == ButtonType.filled;
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? const Color(0xFF65558F) : Colors.transparent,
          foregroundColor: isFilled ? Colors.white : const Color(0xFF65558F),
          side: isFilled
              ? null
              : const BorderSide(color: Color(0xFF65558F), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyContactsSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF65558F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_outlined,
              size: 48,
              color: Color(0xFF65558F),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Contacts Added",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF65558F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Add trusted contacts to share your location with them",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          _buildModernButton(
            text: "Add Contact",
            type: ButtonType.filled,
            icon: Icons.person_add_alt_1_rounded,
            onPressed: () {
              Navigator.pop(context);
              openManageContactsSheet();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactListItem({
    required dynamic contact,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF65558F) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF65558F).withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF65558F),
            size: 24,
          ),
        ),
        title: Text(
          contact.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.phoneNumber,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              contact.email,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF65558F) : Colors.transparent,
            border: Border.all(
              color: isSelected ? const Color(0xFF65558F) : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  void openManageContactsSheet() async {
    await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => ContactFormBottomSheet(
        onSave: (name, phone, email) {
          log('Save contact button is clicked');
          context.read<ContactListBloc>().add(
            AddContactEvent(
              contact: {'name': name, 'phoneNumber': phone, 'email': email},
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 8),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Quick Actions
                        _buildQuickActions(),
                        const SizedBox(height: 32),

                        // Trusted Contacts
                        _buildTrustedContacts(),
                        const SizedBox(height: 32),

                        // Recent Activities
                        _buildRecentActivities(),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SOS Floating Button
          //floatingActionButton: _buildSOSFloatingButton(isEmergency: state.isEmergencyMode),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

          // SOS Overlay
          // ...(state.isEmergencyMode
          //     ? [
          //         Positioned.fill(
          //           child: Container(
          //             color: Colors.red.withOpacity(0.1),
          //           ),
          //         ),
          //       ]
          //     : []),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Safe Campus",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF65558F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your safety is our priority",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF65558F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Alertpage()));
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF65558F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.share_location_outlined,
                title: "Share Route",
                subtitle: "Share real-time location",
                gradient: const LinearGradient(
                  colors: [Color(0xFF65558F), Color(0xFF8B7CB1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: openShareRouteSheet,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.report_outlined,
                title: "Report",
                subtitle: "Report incidents",
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A6FA5), Color(0xFF6B93D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: openReportIncidentSheet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustedContacts() {
    return BlocBuilder<ContactListBloc, ContactListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trusted Contacts",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                if (state is ContactListLoaded && state.contacts.isNotEmpty)
                  TextButton(
                    onPressed: openManageContactsSheet,
                    child: Text(
                      "Add +",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF65558F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (state is ContactListLoading)
              const Center(child: CircularProgressIndicator()),

            if (state is ContactListLoaded)
              state.contacts.isEmpty
                  ? _buildEmptyContactsState()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        //crossAxisSpacing: 16,
                        //mainAxisSpacing: 16,
                        //childAspectRatio: 1.1,
                      ),
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        return HomeTrustedContactContainer(
                          name: contact.name, 
                          email: contact.email,
                          phoneNumber: contact.phoneNumber,
                          isOnline: true,
                          onTap: (){
                            
                          }, 
                          onDelete: (){
                            context.read<ContactListBloc>().add(DeleteContactEvent(contact.email));
                          },
                        );
                      },
                    ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyContactsState() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.5, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF65558F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_add_outlined,
              color: Color(0xFF65558F),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No Contacts Added",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add trusted contacts to share your location",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 20),
          _buildModernButton(
            text: "Add Contact",
            type: ButtonType.filled,
            onPressed: openManageContactsSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(dynamic contact) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF65558F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF65558F),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                contact.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                contact.phoneNumber,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 20),
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<ContactListBloc>().add(DeleteContactEvent(contact.email));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activities",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosHistoryPage()));
              },
              child: Text(
                "See All",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF65558F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<RecentActivityBloc, RecentActivityState>(
          builder: (context, state) {
            if (state is RecentActivitiesLoaded) {
              final activities = state.activities;
              final showCount = activities.length > 3 ? 3 : activities.length;
              final activitiesToShow = activities.take(showCount).toList();

              if (activitiesToShow.isEmpty) {
                return _buildEmptyActivitiesState();
              }

              return Column(
                children: activitiesToShow.map((activity) {
                  return _buildActivityCard(activity);
                }).toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(dynamic activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.report_problem_rounded,
              color: Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SOS Alert",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo(activity.time),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (value) {
              if (value == 'delete') {
                context.read<RecentActivityBloc>().add(DeleteActivityEvent(id: activity.id));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyActivitiesState() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.5, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF65558F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_outlined,
              color: Color(0xFF65558F),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No Recent Activities",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your SOS alerts will appear here",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSOSFloatingButton({required bool isEmergency}) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 20),
  //     child: FloatingActionButton.extended(
  //       onPressed: () {
  //         if (isEmergency) {
  //           _stopSOSMode();
  //         } else {
  //           showSOSBottomSheet(
  //             context: context,
  //             onCancel: () {
  //               Navigator.pop(context);
  //             },
  //           );
  //         }
  //       },
  //       backgroundColor: isEmergency ? Colors.red : const Color(0xFF65558F),
  //       foregroundColor: Colors.white,
  //       elevation: 8,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //       label: Row(
  //         children: [
  //           Icon(isEmergency ? Icons.emergency_rounded : Icons.warning_rounded),
  //           const SizedBox(width: 8),
  //           Text(
  //             isEmergency ? "EMERGENCY ACTIVE" : "SOS EMERGENCY",
  //             style: GoogleFonts.poppins(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

enum ButtonType { filled, outlined }

// Helper function for timestamp formatting
// String formatTimestamp(String timestamp) {
//   // Implement your timestamp formatting logic here
//   return "2 hours ago"; // Placeholder
// }