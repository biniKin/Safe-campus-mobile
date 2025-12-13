import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_datasource.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';

import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';
import 'package:safe_campus/features/contacts/domain/usecases/add_contacts.dart';
import 'package:safe_campus/features/contacts/domain/usecases/delete_contacts.dart';
import 'package:safe_campus/features/contacts/domain/usecases/fetch_contacts.dart';
import 'package:safe_campus/features/contacts/domain/usecases/update_contacts.dart';
import 'package:safe_campus/features/contacts/presentation/bloc/contact_list_bloc.dart';
import 'package:safe_campus/features/contacts/presentation/bloc/contact_list_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/announcement_bloc/announcement_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/auth/login_state.dart';
import 'package:safe_campus/features/core/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/profile/profile_bloc.dart';
import 'package:safe_campus/features/core/presentation/screens/admin/security_dashboard.dart';
import 'package:safe_campus/features/core/presentation/screens/admin_page.dart'
    show AdminPage;
import 'package:safe_campus/features/core/presentation/screens/mapPage.dart';
import 'package:safe_campus/features/report/data/report_data_source.dart';
import 'package:safe_campus/features/report/data/report_repositry._impl.dart';
import 'package:safe_campus/features/report/presentation/bloc/report_bloc.dart';
import 'package:safe_campus/features/report/usecases/send_report.dart';
import 'features/core/presentation/bloc/panic_alert/panic_alert_bloc.dart';
import 'features/core/presentation/firebase_notification_handler.dart';
import 'features/core/presentation/bloc/NavigationCubit.dart';
import 'features/core/presentation/bloc/socket/socket_bloc.dart';
import 'features/core/presentation/screens/home.dart';
import 'features/core/presentation/screens/sos_cubit/sos_cubit.dart';
import 'features/core/presentation/screens/intro_page.dart';
import 'features/core/presentation/screens/sign_in_page.dart';
import 'features/core/presentation/screens/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/core/presentation/bloc/register/register_bloc.dart';
import 'features/core/presentation/bloc/auth/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

 final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

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

  // open hive box
  await Hive.openBox<ContactModelHive>("contactsList");
  

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();
 

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("User permission status: ${settings.authorizationStatus}");
  }

  void checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("App opened from terminated state via notification: ${message.data}");

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
      print(title);
      print(message.data['user']);
      await showNotification(
        title,
        'Tap to view location',
      );
    });

      // navigate 
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        navigatorKey.currentState?.pushNamed(
          '/mapPage',
          arguments: message.data,
        );
      });

    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlertsBloc()),
        BlocProvider(create: (_) => AnnouncementBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<EditProfileBloc>(create: (_) => EditProfileBloc()),
        BlocProvider(create: (_) => PanicAlertBloc()),
        BlocProvider(create: (_) => RegisterBloc()),

        BlocProvider(create: (_) => LoginBloc()),

        BlocProvider(
          create: (context) => NavigationCubit(),
          child: Container(),
        ),
        BlocProvider(create: (_) => SocketBloc()),
        BlocProvider(create: (BuildContext context) => SosCubit()),

        BlocProvider(
          create: (context) => ContactListBloc(
            repository: RepositoryProvider.of<ContactListRepository>(context)
            )..add(LoadContactsEvent()
          )
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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'SafeCampus',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Poppins',
        ),
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              // switch (state.user.role) {
              //   case 'admin':
              //     return const AdminPage();
              //   case 'security':
              //     return const SecurityDashboard();
              //   default:
              return const Home();
              //}
            }
            return const IntroPage();
          },
        ),
        
        routes: {
          
          '/signin': (context) => const SignInPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => const Home(),
          '/mapPage': (context) => const MapPage(),
        },
      ),
    );
  }
}
