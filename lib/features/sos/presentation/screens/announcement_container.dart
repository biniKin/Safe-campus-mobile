import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_campus/core/utls/time_ago.dart';

import 'package:safe_campus/features/sos/data/models/announcement_model.dart';
class AnnouncementContainer extends StatefulWidget {
  final AnnouncementModel annoModel;
  final Widget icon;

  const AnnouncementContainer({
    super.key,
    required this.annoModel,
    required this.icon, 
  });

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  bool isExpanded = false;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon (top-left)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.icon,
              ),

              const SizedBox(width: 12),

              /// Content + Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      widget.annoModel.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(height: 5),

                    /// Description (expandable)
                    Text(
                      widget.annoModel.description,
                      maxLines: isExpanded ? null : 3,
                      overflow:
                          isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    /// Read more / less
                    if (widget.annoModel.description.length > 120)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            isExpanded ? "Read less" : "Read more",
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    /// Date
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        timeAgo(widget.annoModel.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
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
}
