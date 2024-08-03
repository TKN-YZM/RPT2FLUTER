import 'package:hive/hive.dart';

part 'eventlist.g.dart';


@HiveType(typeId: 1)
class EventDaily {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String eventDesc;
  @HiveField(2)
  final DateTime eventDate;
  @HiveField(3)
  bool isCompile;

  EventDaily(
      {required this.id,
      required this.eventDesc,
      required this.eventDate,
      required this.isCompile});
}
