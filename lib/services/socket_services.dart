// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:developer' as developer;
// class SocketService {
//   late IO.Socket _socket;

//   IO.Socket get socket => _socket;

//   void connect(String userId, String token) {
//     _socket = IO.io(
//       'https://safe-campus-backend.onrender.com',
//       IO.OptionBuilder()
//         .setTransports(

//           ['websocket'])
//         .disableAutoConnect()
//         .setAuth(

//        {
//           'token': token,
//         }

//         ) // assuming socketAuth middleware uses `token`
//         .build(),
//     );

//     _socket.connect();

//     _socket.onConnect((_) {
//       developer.log('Connected to /routes namespace');
//       _socket.emit('register_online', userId);
//     });

//     _socket.onDisconnect((_) {
//       developer.log('Disconnected');
//     });

//     _socket.on('some_event', (data) {
//       developer.log('Real-time update: $data');
//     });

//     _socket.onConnectError((err) {
//       developer.log('Connect Error: $err');
//     });

//     _socket.onError((err) {
//       developer.log('General Error: $err');
//     });
//   }

//   void disconnect() {
//     _socket.disconnect();
//   }
// }

import 'dart:async';

import 'package:safe_campus/core/constants/url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer' as developer;

class SocketService {
  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  Future<void> connect({required String token}) async {
    final completer = Completer<void>();
    if (_socket != null && _socket!.connected) {
      developer.log("Socket already connected");
      completer.complete();
      return completer.future;
    }

    _socket = IO.io(
      // 10.2.66.138
      // 'http://10.2.66.138:5000/location_updates',
      '${Url.baseUrl.replaceFirst('/api', '')}/location_updates',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection() // <-- important for mobile networks
          .setReconnectionAttempts(5)
          .setReconnectionDelay(500)
          .setAuth({'token': token}) // <-- backend middleware will use this
          .disableAutoConnect()
          .build(),
    );

    /// Connect socket
    _socket!.connect();

    /// On connect
    _socket!.onConnect((_) {
      developer.log('Connected to socket.');
      completer.complete();
    });

    /// Handle disconnect
    _socket!.onDisconnect((_) {
      developer.log('Socket disconnected');
    });

    /// Handle real-time events
    _socket!.on('some_event', (data) {
      developer.log('Real-time update: $data');
    });

    /// Errors
    _socket!.onConnectError((err) {
      developer.log('Connection error: $err');
    });

    _socket!.onError((err) {
      developer.log('Socket error: $err');
    });

    return completer.future;
  }

  void sendLocation(double lat, double lng, String roomName) {
    _socket?.emit("update_location", {
      "channelId": roomName,
      "location": {"latitude": lat, "longitude": lng},
    });
  }

  void registerOnline(String userId){
    _socket?.emit("register_online", {
      "userId":userId
    });
  }

  void joinChannel(String roomName) {
    _socket?.emit("join_channel", {"channelId": roomName});
  }

  void leaveChannel(String channelName) {
    _socket?.emit("leave_channel", {"channelId": channelName});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
