import 'package:flutter/material.dart';


class Tipcontainer extends StatelessWidget {
  final String content;
  final DateTime? date;
  final icon;

  const Tipcontainer({
    super.key,
    required this.content,
    required this.date,
    this.icon = Icons.gavel_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // KEY LINE
            children: [
              /// Icon (top-left)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: 
                  icon,
                  
              ),

              const SizedBox(width: 12),

              /// Content + Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Rule content
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Date
                    Text(
                      date != null ? _formatDate(date) : "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return "${date?.day}/${date?.month}/${date?.year}";
  }
}
