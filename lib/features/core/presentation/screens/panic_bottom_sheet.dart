import 'package:flutter/material.dart';

void showSOSBottomSheet(BuildContext context, dynamic data) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      final securityTeam = data["securityTeam"] ?? [];
      final trustedContacts = data["trustedContacts"] ?? [];

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Icon(Icons.check_circle, color: Colors.red, size: 60),
            ),

            SizedBox(height: 10),

            Center(
              child: Text(
                "Emergency Request Sent",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Security has been notified and will arrive shortly.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            if (securityTeam.isNotEmpty)
              Text(
                "Responders:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ...securityTeam.map<Widget>((team) => ListTile(
              leading: Icon(Icons.shield, color: Colors.red),
              title: Text(team["name"] ?? "Security Member"),
              subtitle: Text("Phone: ${team["phone"] ?? 'Unknown'}"),
            )),

            SizedBox(height: 10),

            if (trustedContacts.isNotEmpty)
              Text(
                "Trusted Contacts Informed:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ...trustedContacts.map<Widget>((c) => ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(c["name"] ?? "Contact"),
              subtitle: Text(c["phone"] ?? ""),
            )),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
