import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
import 'package:location/location.dart';
import 'dart:developer' as console show log;

class ReportIncidentBottomSheet extends StatefulWidget {
  final Function(String, String) onSubmit;

  const ReportIncidentBottomSheet({super.key, required this.onSubmit});

  @override
  State<ReportIncidentBottomSheet> createState() =>
      _ReportIncidentBottomSheetState();
}

class _ReportIncidentBottomSheetState extends State<ReportIncidentBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  LocationData? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportSuccess) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 10),
                Text(state.message, style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Report Incident",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Incident Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  console.log('Submitting report');

                  context.read<ReportBloc>().add(
                    SendReportEvent(
                      token: 'dkdk',
                      description: descriptionController.text,
                      tags: 'danger',
                      image: 'image will be sent',
                      location: {
                        'latitude': _currentLocation?.latitude.toString() ?? '',
                        'longitude':
                            _currentLocation?.longitude.toString() ?? '',
                      },
                    ),
                  );
                },
                child: const Text("Submit Report"),
              ),
            ],
          ),
        );
      },
    );
  }
}
