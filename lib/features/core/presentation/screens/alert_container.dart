import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_campus/features/core/data/models/alerts_model.dart';
import 'package:safe_campus/features/core/functions/time_ago.dart';

class AlertContainer extends StatefulWidget {
  final AlertsModel alertsModel;
  final icon;
  const AlertContainer({super.key, required this.alertsModel, required this.icon});

  @override
  State<AlertContainer> createState() => _AlertContainerState();
}

// class _AlertContainerState extends State<AlertContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Material(
//         elevation: 2,
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start, // KEY LINE
//             children: [
//               /// Icon (top-left)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: 
//                   widget.icon,
                  
//               ),

//               const SizedBox(width: 12),

//               /// Content + Date
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 130,
//                           height: 20,
//                           child: Text(
//                             overflow: TextOverflow.ellipsis,
//                             widget.alertsModel.title, style: TextStyle(fontWeight: FontWeight.bold),)),
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: widget.alertsModel.status.toLowerCase() == "high" ? Colors.red.withOpacity(0.3) : 
//                               widget.alertsModel.status.toLowerCase() == "medium" ? Colors.amber.withOpacity(0.3) : 
//                               Colors.deepPurpleAccent.withOpacity(0.3)
//                           ),
//                           child: Text(
//                             widget.alertsModel.status, 
//                             style: TextStyle(
//                               color: widget.alertsModel.status.toLowerCase() == "high" ? const Color.fromARGB(255, 75, 8, 3) : 
//                               widget.alertsModel.status.toLowerCase() == "medium" ? const Color.fromARGB(255, 85, 65, 5) : 
//                               const Color.fromARGB(255, 28, 9, 80),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5,),
//                     /// Rule content
//                     Text(
//                       widget.alertsModel.content,
//                       style: TextStyle(
//                         //fontSize: 14,
//                         //height: 1.5,
//                         color: Colors.black.withOpacity(0.7),
//                         fontWeight: FontWeight.w400
//                       ),
//                     ),

//                     const SizedBox(height: 17),

//                     /// Date
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Text(
//                         _formatDate(widget.alertsModel.time),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime? date) {
//     return "${date?.day}/${date?.month}/${date?.year}";
//   }
// }

class _AlertContainerState extends State<AlertContainer> {
  bool _expanded = false;
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black.withOpacity(0.7),
      fontWeight: FontWeight.w400,
    );

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
              /// Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.icon,
              ),

              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 5),

                    /// Alert content + Read more
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final span = TextSpan(
                          text: widget.alertsModel.content,
                          style: textStyle,
                        );

                        final tp = TextPainter(
                          text: span,
                          maxLines: 3,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        _isOverflowing = tp.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 200),
                              crossFadeState: _expanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: Text(
                                widget.alertsModel.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                              secondChild: Text(
                                widget.alertsModel.content,
                                style: textStyle,
                              ),
                            ),

                            if (_isOverflowing)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _expanded = !_expanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      
                                      Text(
                                        _expanded ? "Read less" : "Read more",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),

                                      //_expanded ? Icon(Icons.arrow_back_ios, size: 14,) : Icon(Icons.arrow_forward_ios, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Date
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        timeAgo( widget.alertsModel.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
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

  Widget _buildHeader() {
  final status = widget.alertsModel.status.toLowerCase();

  Color bgColor;
  Color textColor;

  if (status == "high") {
    bgColor = Colors.red.withOpacity(0.3);
    textColor = const Color(0xFF4B0803);
  } else if (status == "medium") {
    bgColor = Colors.amber.withOpacity(0.3);
    textColor = const Color(0xFF554105);
  } else {
    bgColor = Colors.deepPurpleAccent.withOpacity(0.3);
    textColor = const Color(0xFF1C0950);
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        width: 130,
        child: Text(
          widget.alertsModel.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bgColor,
        ),
        child: Text(
          widget.alertsModel.status,
          style: TextStyle(color: textColor),
        ),
      ),
    ],
  );
}

}