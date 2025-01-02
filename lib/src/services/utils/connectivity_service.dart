import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:epicor/src/config/enums/connectivity_status.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  ConnectivityStatus _getStatusFromResult(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.Cellular;
    } else if (result.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.WiFi;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return ConnectivityStatus.Offline;
    } else if (result.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.Offline;
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      return ConnectivityStatus.Offline;
    } else if (result.contains(ConnectivityResult.other)) {
      return ConnectivityStatus.Offline;
    } else {
      return ConnectivityStatus.Offline;
    }
  }
}
