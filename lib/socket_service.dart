import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  void initializeSocket(BuildContext context,
      Function(Map<String, dynamic>) showRideRequestDialog) {
    socket = IO.io('http://10.0.2.2:3003', <String, dynamic>{
      'transports': ['websocket'],
      'path': '/socket.io/',
      'autoConnect': true,
      'reconnection': true,
      'log': true,
    });

    socket?.connect();
    print('bottom sheet ${socket?.connected}');

    socket?.onConnect((_) {
      socket?.emit('driver-connected', '673b32b3305f4b93cb8304dd');
      print('Connected to the server');
    });

    socket?.on("ride-request", (data) {
      showRideRequestDialog(data);
      
    });

    socket?.onDisconnect((_) {
      print('Disconnected to the server');
    });
  }

  void emitRideResponse(String requestId, bool accepted) {
    socket
        ?.emit('ride-response', {'requestId': requestId, 'accepted': accepted});
  }
}
