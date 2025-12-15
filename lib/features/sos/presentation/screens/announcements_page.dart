import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/sos/data/models/announcement_model.dart';
import 'package:safe_campus/features/sos/presentation/bloc/announcement_bloc/announcement_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/announcement_bloc/announcement_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/announcement_bloc/announcement_state.dart';
import 'package:safe_campus/features/sos/presentation/screens/announcement_container.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    context.read<AnnouncementBloc>().add(FetchAnnouncements());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<AnnouncementBloc, AnnouncementState>(
            builder: (context, state) {
              if (state is FetchingAnnouncements) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is FetchedAnnouncements) {
                if (state.announcements.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text("No alerts available")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final alert = state.announcements[index];
                    return AnnouncementContainer(annoModel: alert, icon: Icon(Icons.abc),); // needs fix
                  }, childCount: state.announcements.length),
                );
              } else if (state is FetchAnnouncementsError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Error on fetching alerts. Please try again later",
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return AnnouncementContainer(
                    icon: Icon(Icons.align_vertical_bottom),
                    annoModel: AnnouncementModel(
                      title: "Title",
                      description: "content content content ...",
                      time: DateTime.now(),
                      status: 'High',
                    ),
                  );
                }, childCount: 3),
              );
            },
          ),
        ],
      ),
    );
  }
}
