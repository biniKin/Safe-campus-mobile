import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/alert_service.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/core/data/models/alerts_model.dart';
import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_state.dart';
import 'package:safe_campus/features/core/presentation/screens/alert_container.dart';
import 'package:safe_campus/features/core/presentation/widgets/ongoingContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  final pref = SharedPreferences.getInstance();

  @override
  void initState() {
    context.read<AlertsBloc>().add(FetchAlerts());
    super.initState();
  }

  // void _init()async{
  //   print("init state of alerts");
  //   final alert = AlertService();
  //   await alert.fetchAlerts();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        
        slivers: [
          BlocBuilder<AlertsBloc, AlertsState>(
            builder: (context, state) {
              if (state is FetchingAlerts) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if(state is FetchedAlerts){
                if (state.alerts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text("No alerts available")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final alert = state.alerts[index];
                      return AlertContainer(alertsModel: alert);
                    },
                    childCount: state.alerts.length,
                  )
                );
                
               
              } else if(state is FetchAlertError){
                return SliverFillRemaining(
                  child: Center(
                    child: Text("Error on fetching alerts. Please try again later"),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AlertContainer(
                      alertsModel: AlertsModel(
                        title: "Title",
                        content: "content content content ...",
                        time: DateTime.now(),
                        status: 'High',
                      ),
                    );
                  },
                  childCount: 3,
                ),
              );
            }
          )
        ]
          
        
      )
    );
  }
}