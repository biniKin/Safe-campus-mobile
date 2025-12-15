import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTrustedContactContiner extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HomeTrustedContactContiner({
    super.key,
    required this.name,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPressStart: (details) async {
          final tapPosition =
              details.globalPosition; // Get the global tap position
          final selected = await showMenu<String>(
            context: context,
            position: RelativeRect.fromLTRB(
              tapPosition.dx,
              tapPosition.dy,
              tapPosition.dx,
              tapPosition.dy,
            ),
            items: [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          );

          if (selected == 'delete') {
            print("Delete action triggered");
            // Call your delete logic here, e.g.

            onDelete();
          }
        },

        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFEBEBEB),
          shadowColor: Colors.black.withOpacity(0.9),
          elevation: 2,

          child: SizedBox(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            99,
                            94,
                            139,
                          ).withOpacity(0.2),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/profile.svg",
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        // width: 80,
                        height: 20,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          name,
                          style: const TextStyle(
                            //fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                /// Small circle at top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // status indicator
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
