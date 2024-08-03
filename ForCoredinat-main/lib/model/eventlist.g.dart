// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDailyAdapter extends TypeAdapter<EventDaily> {
  @override
  final int typeId = 1;

  @override
  EventDaily read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventDaily(
      id: fields[0] as int,
      eventDesc: fields[1] as String,
      eventDate: fields[2] as DateTime,
      isCompile: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EventDaily obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventDesc)
      ..writeByte(2)
      ..write(obj.eventDate)
      ..writeByte(3)
      ..write(obj.isCompile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDailyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
