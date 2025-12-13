import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_campus/features/core/data/models/alerts_model.dart';

class AlertContainer extends StatelessWidget {
  final AlertsModel alertsModel;
  const AlertContainer({super.key, required this.alertsModel});

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
                Text(alertsModel.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), 
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent.withOpacity(0.3),
                  ),
                  child: Text(alertsModel.status, style: TextStyle(color: Colors.redAccent),),
                ),
              ],
            ),
            // content
            Text(alertsModel.content),
            Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(alertsModel.time.toString().split(' ')[0]),
                  SizedBox(width: 5,),
                  Text("at ${alertsModel.time.toString().split(' ')[1].split(":")[0]}"),
                ],
              )),
            
          ],
        ),
      ),
    );
  }
}