import 'package:flutter/material.dart';

class ReportIncidentBottomSheet extends StatefulWidget {
  final Function(String, String) onSubmit;

  const ReportIncidentBottomSheet({super.key, required this.onSubmit});

  @override
  State<ReportIncidentBottomSheet> createState() => _ReportIncidentBottomSheetState();
}

class _ReportIncidentBottomSheetState extends State<ReportIncidentBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Report Incident", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              widget.onSubmit(nameController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
