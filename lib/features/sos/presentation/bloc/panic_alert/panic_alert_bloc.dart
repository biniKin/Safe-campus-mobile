import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/services/socket_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'panic_alert_event.dart';
import 'panic_alert_state.dart';
import 'dart:developer' as console show log;

class PanicAlertBloc extends Bloc<PanicAlertEvent, PanicAlertState> {
  final socketService = SocketService();
  StreamSubscription<Position>? _locationSub;
  String roomName = '';
  PanicAlertBloc() : super(PanicInitial()) {
    on<TriggerPanicAlert>(_onTriggerPanicAlert);
    on<CancelPanicAlert>(_cancelPanicAlert);
  }

  Future<void> _onTriggerPanicAlert(
    TriggerPanicAlert event,
    Emitter<PanicAlertState> emit,
  ) async {
    emit(PanicLoading());

    try {
      console.log("on panic alert bloc");

      // 1. check for location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      //if (!serviceEnabled) throw Exception("Location services are disabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      console.log("Token: $token");
      console.log("Triggering panic alert...");

      String refreshToken = prefs.getString('ref_token') ?? '';
      final position = await Geolocator.getCurrentPosition();

      Future<http.Response> sendRequest(String accessToken) {
        // 10.2.66.138
        final uri = Uri.parse('http://10.2.66.138:5000/api/sos/trigger');
        return http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "location": {
              "coordinates": [position.longitude, position.latitude],
            },
          }),
        );
      }

      http.Response response = await sendRequest(token);
      if (response.statusCode == 401) {
        console.log("Token expired → refreshing token...");
        final authService = AuthService(prefs);
        final refreshSuccess = await authService.refreshToken(
          refToken: refreshToken,
        );
        if (refreshSuccess) {
          final newToken = prefs.getString('token') ?? '';
          console.log("Token refreshed successfully!");
          // Retry the request with new token
          response = await sendRequest(newToken);
        } else {
          emit(PanicError("Session expired. Please login again."));
          console.log("error on refreshing token");
          return;
        }
      }

      // FINAL RESPONSE HANDLING
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        roomName = jsonResponse['data']['sosroomId'];
        console.log("Json response: $jsonResponse");
        console.log("Room name: $roomName");
      } else {
        console.log("Error: status ${response.statusCode}");
        emit(PanicError("Failed with status code: ${response.statusCode}"));
      }

      // connect ton
      if (roomName.trim().isNotEmpty) {
        await socketService.connect(token: token);
        socketService.joinChannel(roomName);
        emit(PanicSuccess());
      }

      // start streaming the location using geolocation
      _locationSub = Geolocator.getPositionStream().listen(
        (position) {
          try {
            console.log("Latitude: ${position.latitude}");
            console.log("longtiude: ${position.longitude}");
            // emit the location to the socket
            socketService.sendLocation(
              position.latitude,
              position.longitude,
              roomName,
            );
          } catch (e) {
            console.log("error on streaming location: $e");
          }
        },
        onError: (error) {
          console.log("error: $error");
          emit(PanicError(error));
        },
      );
    } catch (e) {
      console.log("error: $e");

      emit(PanicError(e.toString()));
    }
  }

  Future<void> _cancelPanicAlert(
    CancelPanicAlert event,
    Emitter<PanicAlertState> emit
  )async{
    // disconnect to the 
    final eventId = roomName;
    final uri = Uri.parse( "http://10.2.78.92:5000/api/sos/update/$eventId");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String refreshToken = prefs.getString("ref_token") ?? '';
    
    Future<http.Response> sendRequest(String accessToken) {
        
        return http.put(
          uri,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );
      }

      http.Response response = await sendRequest(token);
      if (response.statusCode == 401) {
        print("Token expired → refreshing token...");
        final authService = AuthService(prefs);
        final refreshSuccess =
            await authService.refreshToken(refToken: refreshToken);
        if (refreshSuccess) {
          final newToken = prefs.getString('token') ?? '';
          print("Token refreshed successfully!");
          // Retry the request with new token
          response = await sendRequest(newToken);
        } else {
          emit(PanicError("Session expired. Please login again."));
          print("error on refreshing token");
          return;
        }
      }

      
      // FINAL RESPONSE HANDLING
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(jsonDecode(response.body));
        
        
      } else {
        print("Error: status ${response.statusCode}");
        emit(PanicError("Failed with status code: ${response.statusCode}"));
      }
    

    _locationSub?.cancel();
    socketService.leaveChannel(roomName);
    socketService.disconnect();
  }
}
