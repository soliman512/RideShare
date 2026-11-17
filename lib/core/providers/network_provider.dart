
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkProvider extends ChangeNotifier {
  final InternetConnection _internetConnection = InternetConnection();

  StreamSubscription<InternetStatus>? _subscription;

  bool _hasInternet = true;
  bool _isChecking = false;

  bool get hasInternet => _hasInternet;
  bool get isChecking => _isChecking;

  // Start monitoring
  Future<void> startMonitoring() async {
    _subscription = _internetConnection.onStatusChange.listen(
      (status) {
        _updateConnectionStatus(
          status == InternetStatus.connected,
        );
      },
    );

    await checkConnection();
  }

  // Check connection
  Future<bool> checkConnection() async {
    try {
      final isConnected =
          await _internetConnection.hasInternetAccess;

      _updateConnectionStatus(isConnected);

      return isConnected;
    } catch (e) {
      _updateConnectionStatus(false);
      return false;
    }
  }

  // Retry connection
  Future<bool> retryConnection() async {
    _isChecking = true;
    notifyListeners();

    final result = await checkConnection();

    _isChecking = false;
    notifyListeners();

    return result;
  }

  // Update connection status
  void _updateConnectionStatus(bool status) {
    if (_hasInternet == status) return;

    _hasInternet = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
