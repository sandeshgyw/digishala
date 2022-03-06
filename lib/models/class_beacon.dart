import 'package:digishala/screens/authorized_home.dart';

class ClassBeacon {
  String className;
  String uuid;
  String id;

  ClassBeacon({this.className, this.uuid, this.id});

  toMap() {
    return {
      "className": className,
      "uuid": uuid,
      "id": id,
    };
  }

  static ClassBeacon fromMap(Map<String, dynamic> json) {
    if (json == null) return null;
    return ClassBeacon()
      ..className = json["className"]
      ..uuid = json["uuid"]
      ..id = json["id"];
  }

  ClassBeacon fromRoomAttendance(RoomAttendance roomAttendance) {
    return ClassBeacon()
      ..className = roomAttendance.roomName
      ..id = roomAttendance.roomKey;
  }
}
