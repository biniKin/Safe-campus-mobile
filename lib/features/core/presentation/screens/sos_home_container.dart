import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:safe_campus/features/core/functions/time_ago.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
class SosHomeContainer extends StatelessWidget {
  final String title;
  final DateTime time;
  final VoidCallback onDelete;
  const SosHomeContainer({
    super.key,
    required this.time,
    required this.title,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      height: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 241, 241, 241),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.report_problem_rounded, color: Colors.red,)
          ),
          const SizedBox(width: 12),

          // Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo(time),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

            // More icon
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                // Handle delete action here
                print('Delete tapped for: $title');
                onDelete();
                
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
