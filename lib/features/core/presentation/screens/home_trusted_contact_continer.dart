// import 'package:flutter/material.dart';

// class HomeTrustedContactContiner extends StatelessWidget {
//   final String name;
//   const HomeTrustedContactContiner({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color(0xFFEBEBEB),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 3,
//               offset: Offset(0, 0)
//             ),
//           ],
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//               Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xFF6050D5).withOpacity(0.3),
//                   ),
//                   padding: EdgeInsets.all(10),
//                   child: Icon(Icons.person, size: 35,),
//                 ),
//                 Text(name)
//               ],
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Container(
//                 height: 12,
//                 width: 12,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.green, // status indicator
//                 ),
//               ),
//             ),
//           ]
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTrustedContactContainer extends StatelessWidget {
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? avatarInitial;
  final Color avatarColor;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isOnline;

  const HomeTrustedContactContainer({
    super.key,
    required this.name,
    this.phoneNumber,
    this.email,
    this.avatarInitial,
    this.avatarColor = const Color(0xFF65558F),
    required this.onTap,
    required this.onDelete,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteMenu(context),
      child: Container(
        
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar with gradient
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          avatarColor,
                          Color.lerp(avatarColor, Colors.white, 0.3)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: avatarInitial != null
                              ? Text(
                                  avatarInitial!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                              : SvgPicture.asset(
                                  "assets/icons/profile.svg",
                                  height: 28,
                                  color: Colors.white,
                                ),
                        ),
                        // Online indicator
                        if (isOnline)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Phone number (if provided)
                  // if (phoneNumber != null && phoneNumber!.isNotEmpty)
                  //   Text(
                  //     phoneNumber!,
                  //     style: GoogleFonts.poppins(
                  //       fontSize: 12,
                  //       color: Colors.grey.shade600,
                  //     ),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     textAlign: TextAlign.center,
                  //   ),

                  // // Email (if provided)
                  // if (email != null && email!.isNotEmpty)
                  //   Text(
                  //     email!,
                  //     style: GoogleFonts.poppins(
                  //       fontSize: 11,
                  //       color: Colors.grey.shade500,
                  //     ),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     textAlign: TextAlign.center,
                  //   ),

                  // Quick action buttons (appear on hover in web, always visible in mobile)
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Call button
                      _buildQuickActionButton(
                        icon: Icons.call_outlined,
                        color: const Color(0xFF65558F),
                        onPressed: () {
                          if (phoneNumber != null) {
                            // Implement call functionality
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      // Message button
                      _buildQuickActionButton(
                        icon: Icons.message_outlined,
                        color: const Color(0xFF65558F),
                        onPressed: () {
                          if (phoneNumber != null) {
                            // Implement message functionality
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete button (top right)
            // Positioned(
            //   top: 8,
            //   right: 8,
            //   child: GestureDetector(
            //     onTap: onDelete,
            //     child: Container(
            //       width: 24,
            //       height: 24,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         shape: BoxShape.circle,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.2),
            //             blurRadius: 4,
            //             offset: const Offset(0, 2),
            //           ),
            //         ],
            //       ),
            //       child: const Icon(
            //         Icons.close_rounded,
            //         size: 14,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),

            // Hover overlay
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    splashColor: const Color(0xFF65558F).withOpacity(0.1),
                    highlightColor: const Color(0xFF65558F).withOpacity(0.05),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 14,
          color: color,
        ),
        padding: EdgeInsets.zero,
        splashRadius: 14,
      ),
    );
  }

  void _showDeleteMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          avatarColor,
                          Color.lerp(avatarColor, Colors.white, 0.3)!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: avatarInitial != null
                          ? Text(
                              avatarInitial!,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/icons/profile.svg",
                              height: 24,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (phoneNumber != null)
                          Text(
                            phoneNumber!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        if (email != null)
                          Text(
                            email!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildMenuOption(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Contact',
                subtitle: 'Remove from trusted contacts',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              // const SizedBox(height: 16),
              // _buildMenuOption(
              //   icon: Icons.message_outlined,
              //   title: 'Send Message',
              //   subtitle: 'Send a text message',
              //   color: const Color(0xFF65558F),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Implement message functionality
              //   },
              // ),
              const SizedBox(height: 16),
              _buildMenuOption(
                icon: Icons.call_outlined,
                title: 'Make a Call',
                subtitle: 'Call this contact',
                color: const Color(0xFF65558F),
                onTap: () {
                  Navigator.pop(context);
                  // Implement call functionality
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example in GridView:
// GridView.builder(
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 0.8,
//   ),
//   itemCount: contacts.length,
//   itemBuilder: (context, index) {
//     final contact = contacts[index];
//     final avatarInitial = contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';
//     final avatarColor = _getAvatarColor(index);
//     
//     return ModernHomeTrustedContactContainer(
//       name: contact.name,
//       phoneNumber: contact.phone,
//       email: contact.email,
//       avatarInitial: avatarInitial,
//       avatarColor: avatarColor,
//       onTap: () => _showContactDetails(contact),
//       onDelete: () => _deleteContact(contact),
//       isOnline: contact.isOnline,
//     );
//   },
// )
// 
// Color _getAvatarColor(int index) {
//   final colors = [
//     const Color(0xFF65558F), // Primary purple
//     const Color(0xFF4A6FA5), // Blue
//     const Color(0xFF2E8B57), // Green
//     const Color(0xFFD2691E), // Orange
//     const Color(0xFF8B0000), // Red
//   ];
//   return colors[index % colors.length];
// }