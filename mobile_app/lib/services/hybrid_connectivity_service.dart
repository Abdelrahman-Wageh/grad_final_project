/// Hybrid Connectivity Service
/// Manages online/offline state and automatic switching
library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus {
  online,
  offline,
  unknown,
}

class HybridConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnectivityStatus _status = ConnectivityStatus.unknown;
  StreamSubscription<ConnectivityResult>? _subscription;
  
  ConnectivityStatus get status => _status;
  bool get isOnline => _status == ConnectivityStatus.online;
  bool get isOffline => _status == ConnectivityStatus.offline;
  
  HybridConnectivityService() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
    
    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }
  
  void _updateStatus(ConnectivityResult result) {
    final newStatus = result == ConnectivityResult.none
        ? ConnectivityStatus.offline
        : ConnectivityStatus.online;
    
    if (newStatus != _status) {
      _status = newStatus;
      notifyListeners();
      
      if (kDebugMode) {
        print('Connectivity changed: ${_status.name}');
      }
    }
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
