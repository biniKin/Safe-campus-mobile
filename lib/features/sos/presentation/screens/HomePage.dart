import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:safe_campus/core/utls/time_ago.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';

import 'package:safe_campus/features/core/presentation/screens/alertPage.dart';
import 'package:safe_campus/features/core/presentation/screens/home_trusted_contact_continer.dart';
import 'package:safe_campus/features/sos/presentation/bloc/contacts_bloc/contact_list_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/contacts_bloc/contact_list_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/contacts_bloc/contact_list_state.dart';
import 'package:safe_campus/features/sos/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/recent_activity_bloc/recent_activity_state.dart';
import 'package:safe_campus/features/sos/presentation/bloc/share_route_bloc/share_route_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/share_route_bloc/share_route_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/share_route_bloc/share_route_state.dart';
import 'package:safe_campus/features/sos/presentation/screens/sos_cubit/sos_cubit.dart';
import 'package:safe_campus/features/sos/presentation/screens/sos_history_page.dart';
import 'package:safe_campus/features/sos/presentation/widgets/contact_form_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';

import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends State<HomePage> {
  
  Timer? _sosPulseTimer;
  bool _isLoading = false;
  final location = Geolocator.getCurrentPosition();

  @override
  void initState(){
    super.initState();
    
    
    log('ModernHomePage initialized');
  }

  @override
  void dispose() {
    _sosPulseTimer?.cancel();
    super.dispose();
  }

  Future<void> openDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch dialer';
    }
  }

  void _stopSOSMode() {
    context.read<SosCubit>().offEmergencyMode();
    _sosPulseTimer?.cancel();
  }
  Future<Position> getCurrentLocation() async {
  // 1. Check if location service is enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // 2. Check permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permissions are permanently denied, enable them from settings.',
    );
  }

  // 3. Get position
    return await Geolocator.getCurrentPosition(
      
    );
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
                                              final position = await getCurrentLocation();

                                              final double latitude = position.latitude;
                                              final double longitude = position.longitude;

                                                final prefs = await SharedPreferences.getInstance();
                                                final token = prefs.getString('token') ?? '';
                                                 print("current location to submit ${latitude} and ${longitude}");

                                                context.read<ReportBloc>().add(
                                                  SendReportEvent(
                                                    description: descriptionController.text,
                                                    tags: '$selectedType, $selectedSeverity',
                                                    image: selectedMedia?.path ?? '',
                                                    location: {
                                                      "type": "Point",
                                                      "coordinates": [
                                                        latitude ?? 0.0,
                                                        longitude ?? 0.0,
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
  // void openShareRouteSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return BlocBuilder<ContactListBloc, ContactListState>(
  //         builder: (context, state) {
  //           if (state is ContactListLoaded) {
  //             final contacts = state.contacts;

  //             if (contacts.isEmpty) {
  //               return _buildEmptyContactsSheet();
  //             }

  //             // Track selection per contact
  //             List<bool> selected = List.generate(contacts.length, (_) => false);

  //             return StatefulBuilder(
  //               builder: (context, setState) {
  //                 return Container(
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(24),
  //                       topRight: Radius.circular(24),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       // Header
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
  //                         child: Column(
  //                           children: [
  //                             Center(
  //                               child: Container(
  //                                 width: 40,
  //                                 height: 4,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.grey.shade300,
  //                                   borderRadius: BorderRadius.circular(2),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(height: 20),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text(
  //                                   "Share Location",
  //                                   style: GoogleFonts.poppins(
  //                                     fontSize: 24,
  //                                     fontWeight: FontWeight.w700,
  //                                     color: const Color(0xFF65558F),
  //                                   ),
  //                                 ),
  //                                 IconButton(
  //                                   onPressed: () => Navigator.pop(context),
  //                                   icon: const Icon(Icons.close_rounded),
  //                                   color: Colors.grey.shade600,
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 8),
  //                             Text(
  //                               "Select contacts to share your real-time location",
  //                               style: GoogleFonts.poppins(
  //                                 fontSize: 14,
  //                                 color: Colors.grey.shade600,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(height: 24),

  //                       // Contact List
  //                       Expanded(
  //                         child: ListView.builder(
  //                           padding: const EdgeInsets.symmetric(horizontal: 16),
  //                           shrinkWrap: true,
  //                           itemCount: contacts.length,
  //                           itemBuilder: (context, index) {
  //                             final contact = contacts[index];
  //                             return _buildContactListItem(
  //                               contact: contact,
  //                               isSelected: selected[index],
  //                               onTap: () {
  //                                 setState(() => selected[index] = !selected[index]);
  //                               },
  //                             );
  //                           },
  //                         ),
  //                       ),

  //                       // Share Button
  //                       // Padding(
  //                       //   padding: const EdgeInsets.all(24),
  //                       //   child: _buildModernButton(
  //                       //     text: "Share Location",
  //                       //     type: ButtonType.filled,
  //                       //     icon: Icons.share_outlined,
  //                       //     onPressed: () {
  //                       //       print("on sharing contacts............");
  //                       //       // Collect selected contacts
  //                       //       List<Contact> selectedContacts = [];
  //                       //       for (int i = 0; i < contacts.length; i++) {
  //                       //         if (selected[i]) {
  //                       //           selectedContacts.add(contacts[i]);
  //                       //         }
  //                       //       }

  //                       //       if (selectedContacts.isEmpty) {
  //                       //         ScaffoldMessenger.of(context).showSnackBar(
  //                       //           const SnackBar(content: Text("Please select at least one contact")),
  //                       //         );
  //                       //         return;
  //                       //       }

  //                       //       // Trigger Bloc event
  //                       //       context.read<ShareRouteBloc>().add(
  //                       //             ShareRouteRequested(
  //                       //               coordinates: {"coordinates": [18.0093, 20.3848]},
  //                       //               contacts: selectedContacts,
  //                       //             ),
  //                       //           );

  //                       //       print('Sharing location with: ${selectedContacts.map((c) => c.email).toList()}');
  //                       //       Navigator.pop(context);
  //                       //     },

  //                       //   ),
  //                       // ),
  //                       // Share Button with BlocBuilder
  //                       Padding(
  //                         padding: const EdgeInsets.all(24),
  //                         child: BlocBuilder<ShareRouteBloc, ShareRouteState>(
  //                           builder: (context, state) {
  //                             // Show loader while sharing
  //                             if (state is ShareRouteLoading) {
  //                               return const Center(
  //                                 child: CircularProgressIndicator(),
  //                               );
  //                             }
                        
  //                             return _buildModernButton(
  //                               text: "Share Location",
  //                               type: ButtonType.filled,
  //                               icon: Icons.share_outlined,
  //                               onPressed: () {
  //                                 print("on sharing contacts............");
  //                                 // Collect selected contacts
  //                                 List<Contact> selectedContacts = [];
  //                                 for (int i = 0; i < contacts.length; i++) {
  //                                   if (selected[i]) {
  //                                     selectedContacts.add(contacts[i]);
  //                                   }
  //                                 }
                        
  //                                 if (selectedContacts.isEmpty) {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     const SnackBar(content: Text("Please select at least one contact")),
  //                                   );
  //                                   return;
  //                                 }
                        
  //                                 // Trigger Bloc event
  //                                 context.read<ShareRouteBloc>().add(
  //                                       ShareRouteRequested(
  //                                         coordinates: {"coordinates": [18.0093, 20.3848]},
  //                                         contacts: selectedContacts,
  //                                       ),
  //                                     );
                        
  //                                 print('Sharing location with: ${selectedContacts.map((c) => c.email).toList()}');
  //                                 // Optionally do NOT pop immediately; wait for success/failure
  //                               },
  //                             );
  //                           },
  //                         ),
  //                       ),

  //                     ],
  //                   ),
  //                 );
  //               },
  //             );
  //           }
  //           return const Center(child: CircularProgressIndicator());
  //         },
  //       );
  //     },
  //   );
  // }
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
                return BlocListener<ShareRouteBloc, ShareRouteState>(
                  listener: (context, shareState) {
                    if (shareState is ShareRouteSuccess) {
                      Navigator.pop(context); // Close sheet on success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Location shared successfully!")),
                      );

                      Fluttertoast.showToast(msg: "Location shared successfully!");
                      
                    } else if (shareState is ShareRouteFailure) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text(shareState.message)),
                      // );
                      Fluttertoast.showToast(msg: shareState.message);
                    }
                  },
                  child: Container(
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

                        // Share Button with BlocBuilder
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: BlocBuilder<ShareRouteBloc, ShareRouteState>(
                            builder: (context, shareState) {
                              if (shareState is ShareRouteLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return _buildModernButton(
                                text: "Share Location",
                                type: ButtonType.filled,
                                icon: Icons.share_outlined,
                                onPressed: () {
                                  // Collect selected contacts
                                  List<Contact> selectedContacts = [];
                                  for (int i = 0; i < contacts.length; i++) {
                                    if (selected[i]) {
                                      selectedContacts.add(contacts[i]);
                                    }
                                  }

                                  if (selectedContacts.isEmpty) {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text("Please select at least one contact"),
                                    //   ),
                                    // );
                                    Fluttertoast.showToast(msg: "Please select at least one contact");
                                    return;
                                  }

                                  // Trigger Bloc event
                                  context.read<ShareRouteBloc>().add(
                                        ShareRouteRequested(
                                          coordinates: {"coordinates": [18.0093, 20.3848]},
                                          contacts: selectedContacts,
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
        height: 170,
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
                          //isOnline: true,
                          onTap: (){
                            
                          },
                          onCall: (){
                            /// 
                            /// 
                            openDialer(contact.phoneNumber);
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
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
      //height: 140,
      padding: EdgeInsets.all(20),
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

  
}

enum ButtonType { filled, outlined }
