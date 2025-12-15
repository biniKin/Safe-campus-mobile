import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_campus/features/sos/data/models/announcement_model.dart';

class AnnouncementContainer extends StatelessWidget {
  final AnnouncementModel announcementModel;
  const AnnouncementContainer({super.key, required this.announcementModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  announcementModel.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent.withOpacity(0.3),
                  ),
                  child: Text(
                    announcementModel.status,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
            // content
            Text(announcementModel.description),
            Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(announcementModel.time.toString().split(' ')[0]),
                  SizedBox(width: 5),
                  Text(
                    "at ${announcementModel.time.toString().split(' ')[1].split(":")[0]}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
