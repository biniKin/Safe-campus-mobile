import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
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
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF9F9F9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Report icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.report,
              color: Color.fromARGB(255, 255, 200, 2),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2,'0')}",
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
                onDelete;
                
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
