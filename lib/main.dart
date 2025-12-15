import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_datasource.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model_hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';
import 'package:safe_campus/features/contacts/data/repository/contact_list_local_imp.dart';
import 'package:safe_campus/features/contacts/data/repository/contact_repo_imp.dart';
import 'dart:developer' as console show log;
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';
import 'package:safe_campus/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:safe_campus/features/sos/presentation/bloc/contacts_bloc/contact_list_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/contacts_bloc/contact_list_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/alerts_bloc/alerts_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/announcement_bloc/announcement_bloc.dart';
import 'package:safe_campus/features/auth/presentation/bloc/login_state.dart';
import 'package:safe_campus/features/sos/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/profile/profile_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/recent_activity_bloc/recent_activity_bloc.dart';
import 'package:safe_campus/features/sos/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/map_marking/data/data_source/map_remote_datasource.dart';
import 'package:safe_campus/features/map_marking/data/repository/map_repository_impl.dart';
import 'package:safe_campus/features/map_marking/domain/usecase/get_danger_areas.dart';
import 'package:safe_campus/features/map_marking/presentation/bloc/map_bloc.dart';
import 'package:safe_campus/features/map_marking/presentation/page/map_page.dart';

import 'package:safe_campus/features/report/data/data_source/report_data_source.dart';
import 'package:safe_campus/features/report/data/repository/report_repositry._impl.dart';
import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
import 'package:safe_campus/features/report/domain/usecases/send_report.dart';
import 'features/sos/presentation/bloc/panic_alert/panic_alert_bloc.dart';
import 'services/firebase/firebase_notification_handler.dart';
import 'features/sos/presentation/bloc/NavigationCubit.dart';
import 'features/sos/presentation/bloc/socket/socket_bloc.dart';
import 'features/sos/presentation/screens/home.dart';
import 'features/sos/presentation/screens/sos_cubit/sos_cubit.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/sos/presentation/bloc/register/register_bloc.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // hive
  await Hive.initFlutter();
  Hive.registerAdapter(ContactModelHiveAdapter());
  Hive.registerAdapter(ActivityModelHiveAdapter());

  // open hive box
  final box = await Hive.openBox<ContactModelHive>("contactsList");
  await Hive.openBox<ActivityModelHive>("recent_activities");

  // Concrete datasources
  final local = ContactLocalDataSourceImpl(box);
  final remote = ContactListDatasourceImpl(
    prefs: prefs,
    authService: AuthService(prefs), // your actual AuthService
  );

  // Repository
  final contactRepo = ContactRepositoryImpl(remote: remote, local: local);

  runApp(
    RepositoryProvider<ContactListRepository>(
      create: (_) => contactRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AlertsBloc()),
          BlocProvider(create: (_) => AnnouncementBloc()),
          BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
          BlocProvider<EditProfileBloc>(create: (_) => EditProfileBloc()),
          BlocProvider(create: (_) => PanicAlertBloc()),
          BlocProvider(create: (_) => RegisterBloc()),
          BlocProvider(
            create: (_) => RecentActivityBloc()..add(LoadActivitiesEvent()),
          ),

          BlocProvider(create: (_) => LoginBloc()),

          BlocProvider(
            create: (context) => NavigationCubit(),
            child: Container(),
          ),
          BlocProvider(create: (_) => SocketBloc()),
          BlocProvider(create: (BuildContext context) => SosCubit()),

          BlocProvider<ContactListBloc>(
            create:
                (context) => ContactListBloc(
                  repository: RepositoryProvider.of<ContactListRepository>(
                    context,
                  ),
                )..add(LoadContactsEvent()),
          ),

          BlocProvider(
            create:
                (_) => ReportBloc(
                  sendReport: SendReport(
                    reportRepositryImpl: ReportRepositryImpl(
                      reportDatasource: ReportDataSourceImpl(),
                    ),
                  ),
                ),
          ),

          BlocProvider(
            create:
                (context) => MapBloc(
                  getDangerAreas: GetDangerAreas(
                    MapRepositoryImpl(
                      MapRemoteDataSourceImpl(HttpClient(), prefs: prefs),
                    ),
                  ),
                ),
          ),
        ],

        child: MyApp(prefs: prefs),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    console.log("User permission status: ${settings.authorizationStatus}");
  }

  void checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      console.log(
        "App opened from terminated state via notification: ${message.data}",
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamed(
          '/mapPage',
          arguments: message.data,
        );
      });
    }
  }

  @override
  void initState() {
    requestNotificationPermission();
    checkInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = parseAlertTitle(message.data);
      console.log(title);
      console.log(message.data['user']);
      await showNotification(title, 'Tap to view location');
    });

    // navigate
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/mapPage', arguments: message.data);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seen = widget.prefs.getBool('onboardingDone') ?? false;

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'SafeCampus',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Poppins'),
      home: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginSuccess) {
            return const Home();
            //}
          }
          return seen ? const SignInPage() : const OnboardingPage();
        },
      ),

      routes: {
        '/signin': (context) => const SignInPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const Home(),
        '/mapPage': (context) => const MapPage(),
      },
    );
  }
}
