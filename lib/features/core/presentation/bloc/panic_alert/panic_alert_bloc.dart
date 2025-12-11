import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'panic_alert_event.dart';
import 'panic_alert_state.dart';

class PanicAlertBloc extends Bloc<PanicAlertEvent, PanicAlertState> {
  PanicAlertBloc() : super(PanicInitial()) {
    on<TriggerPanicAlert>(_onTriggerPanicAlert);
  }

  // Future<void> _onTriggerPanicAlert(
  //   TriggerPanicAlert event,
  //   Emitter<PanicAlertState> emit,
  // ) async {
  //   emit(PanicLoading());

  //   try {
  //     print("on panic alert bloc");
  //     // 1. Get current location
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) throw Exception("Location services are disabled");

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       print("permission denied");
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         print("permission denied");
  //         throw Exception("Location permission denied");
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition();
  //     final prefs = await SharedPreferences.getInstance();
                  
  //     final token = prefs.getString('token')?? '';
  //     final refreshToken = prefs.getString('ref_token') ?? '';
  //     final deviceToken = FirebaseMessaging.instance.getToken();
  //     print(token);
  //     print("about to hit http");

  //     try{
  //       final uri = Uri.parse('http://10.2.75.1:5000/api/sos/trigger');
  //       print("Sending Authorization: Bearer $token");


  //       final response = await http.post(
  //         uri,
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode({
  //           "location": {
  //             "coordinates": [position.longitude, position.latitude],
  //           }
  //         }),
  //       );


  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final jsonResponse = jsonDecode(response.body);
  //         print(jsonResponse);
  //         emit(PanicSuccess(jsonResponse));
  //       } else if (response.statusCode == 401){
  //         // refresh token
  //         final _auth = AuthService(prefs);
          
  //         final refreshSuccess = await _auth.refreshToken(refToken: refreshToken);

  //         if(refreshSuccess){
  //           final newToken = prefs.getString('token');
  //           return await _onTriggerPanicAlert();
  //         }
  //       } else{
  //         print("on else block ${response.statusCode}");
  //         emit(PanicError("Failed with status code: ${response.statusCode}"));
  //       }
  //     }catch(e){
  //       print(e);
  //     }
      
  //   } catch (e) {
  //     print("error: $e");
  //     emit(PanicError(e.toString()));
  //   }
  // }
  Future<void> _onTriggerPanicAlert(
  TriggerPanicAlert event,
  Emitter<PanicAlertState> emit,
) async {
  emit(PanicLoading());

  try {
    print("on panic alert bloc");

    // 1. Get current location
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    String refreshToken = prefs.getString('ref_token') ?? '';

    print("Token: $token");
    print("Triggering panic alert...");

    
    Future<http.Response> sendRequest(String accessToken) {
      final uri = Uri.parse('http://10.2.75.1:5000/api/sos/trigger');

      return http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "location": {
            "coordinates": [position.longitude, position.latitude],
          }
        }),
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
        return;
      }
    }

    // FINAL RESPONSE HANDLING
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      emit(PanicSuccess(jsonResponse));
    } else {
      print("Error: status ${response.statusCode}");
      emit(PanicError("Failed with status code: ${response.statusCode}"));
    }
  } catch (e) {
    print("error: $e");
    emit(PanicError(e.toString()));
  }
}

}
