// File: network_info.dart
// Location: lib/core/network/
//
// Purpose:
// Defines a contract (`NetworkInfo`) and its implementation (`NetworkInfoImpl`) for checking internet connectivity.
// Used in the Data Layer to verify if network operations should proceed.
//
// Relies on the `connectivity_plus` package.
//
// Clean Architecture Note:
// This sits in the **Core Layer** as a shared infrastructure service.

import 'package:reels_ulearna/core/constants/imports.dart';

/// Abstract contract for checking internet connection status.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation using the `connectivity_plus` plugin.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }
}
