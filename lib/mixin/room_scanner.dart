import 'dart:async';

import 'package:digishala/models/room.dart';
import 'package:digishala/screens/authorized_home.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

mixin RoomScanner<T extends StatefulWidget> on State<T> {
  List<Room> rooms;
  Map<String, RoomAttendance> roomAttendances = {};
  Room room = Room(); //just for test

  double minimumSecondsToStay = 5;
  StreamSubscription _sub;
  Timer _cancelTimer;
  StreamSubscription<BluetoothState> bluetoothStateStreamSubscription;

  Scanner scanner = Scanner();

  Future<void> getPermission() async {
    BluetoothPermissionState permissionState =
        await snowmScanner.getPermissionState();
    if (permissionState == BluetoothPermissionState.UNKNOWN ||
        permissionState == BluetoothPermissionState.DENIED) {
      snowmScanner.requestPermission();
    }
  }

  _handleCleaner() {
    _cancelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      roomAttendances.forEach((roomKey, roomAttendance) async {
        if (roomAttendance.lastScannedTime == null) return;
        if (roomAttendance.lastScannedTime
                    .difference(DateTime.now())
                    .inSeconds *
                -1 >
            minimumSecondsToStay) {
          roomAttendance.exitTime = DateTime.now();

          onExited(roomAttendance);
          roomAttendance.entryTime = null;
          roomAttendance.exitTime = null;
          roomAttendance.lastScannedTime = null;
          roomAttendance.firstScannedTime = null;
        }
      });
    });
  }

  startRoomScanner(List<Room> classRooms) async {
    // TODO: Fetch rooms

    rooms = classRooms;
    rooms.forEach((r) {
      roomAttendances[r.key] = RoomAttendance(r);
    });

    await getPermission();
    bluetoothStateStreamSubscription =
        scanner.bluetoothStateStream.listen((bluetoothState) {
      if (bluetoothState == BluetoothState.OFF)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please turn your bluetooth on for attendance track"),
          ),
        );
      return bluetoothState;
    });
    scanBeacons();
  }

  scanBeacons() {
    // snowmScanner.scanIBeacons(scanAllIBeacons: true).listen((event) {
    //   print(event);
    // });
    _sub = snowmScanner
        .scanIBeacons(
      uuids: rooms
          .map((r) => r.uuids)
          // Study about this
          .reduce((accumulator, current) => [...accumulator, ...current])
          .toList(),
    )
        .listen((List<SnowMBeacon> beacons) {
      beacons.forEach((beacon) {
        Room room = rooms.firstWhere(
          (r) => r.uuids.contains(beacon.uuid.toUpperCase()),
          orElse: () => null,
        );
        if (room == null) return;
        RoomAttendance roomAttendance = roomAttendances[room.key];
        if (roomAttendance.lastScannedTime == null) {
          roomAttendance.lastScannedTime = DateTime.now();
          roomAttendance.firstScannedTime = DateTime.now();
        } else {
          Duration scannedDuration = roomAttendance.firstScannedTime
              .difference(roomAttendance.lastScannedTime);
          if (scannedDuration.inSeconds * -1 > minimumSecondsToStay) {
            print(scannedDuration.inSeconds * -1);
            roomAttendance.entryTime = DateTime.now();

            onEntered(roomAttendance);
          }
        }
        roomAttendance.lastScannedTime = DateTime.now();
        roomAttendances[room.key] = roomAttendance;
      });
      //check first connect and disconnect and upload after disconnect
    });
    _handleCleaner();
  }

  onEntered(RoomAttendance roomAttendance) {
    firebase.setClassRoom(roomAttendance);
    //TODO:
  }

  onExited(RoomAttendance roomAttendance) {
    var format = DateFormat.yMd();
    roomAttendance.date = format.format(DateTime.now());
    firebase.setTeacherAttendance(roomAttendance);
    //TODO:
  }

  disposeScanner() async {
    await bluetoothStateStreamSubscription?.cancel();
    await _sub?.cancel();
    await _cancelTimer?.cancel();
  }
}
