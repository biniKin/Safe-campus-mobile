import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_state.dart' show RecentActivitiesLoaded, RecentActivityState;
import 'package:safe_campus/features/core/presentation/screens/sos_home_container.dart';

class SosHistoryPage extends StatelessWidget {
  const SosHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Activities"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: BlocBuilder<RecentActivityBloc, RecentActivityState>(
            builder: (context, state) {
              if(state is RecentActivitiesLoaded){
                final activities = state.activities;
                return activities.isEmpty ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_empty_rounded, size: 100,color: Colors.grey,),
                      Text("No recent activity found."),
                    ],
                  ),) : 
                  
                  ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index){
                    final acti = activities[index];
                    return SosHomeContainer(
                      time: acti.time, 
                      title: "SOS Alert", onDelete: (){
                        context.read<RecentActivityBloc>().add(DeleteActivityEvent(id: acti.id));
                      },
                    );
                  }
                );
              }
              return Center(
                child: Text("No recent activity found.", style: TextStyle(color: Colors.grey),),
              );
            }
          ),
        ),
      ),
    );
  }
}