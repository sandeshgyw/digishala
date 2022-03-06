import 'dart:async';

import 'package:snowm_scanner/snowm_scanner.dart';

class Scanner {
  Stream<BluetoothState> bluetoothStateStream;
  Scanner() {
    bluetoothStateStream =
        snowmScanner.getBluetoothStateStream().asBroadcastStream();
  }
}
