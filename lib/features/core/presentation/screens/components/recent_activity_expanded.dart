import 'package:flutter/material.dart';

class RecentActivityExpanded extends StatelessWidget {
  final List<Map<String, String>> activities;

  const RecentActivityExpanded({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.report),
            title: Text(activity['name'] ?? ''),
            subtitle: Text(activity['description'] ?? ''),
          ),
        );
      },
    );
  }
}
