// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_calendar_color.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveCalendarColorAdapter extends TypeAdapter<SaveCalendarColor> {
  @override
  final int typeId = 1;

  @override
  SaveCalendarColor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveCalendarColor(
      todayColorValue: fields[0] as int,
      selectedDayColorValue: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SaveCalendarColor obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.todayColorValue)
      ..writeByte(1)
      ..write(obj.selectedDayColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveCalendarColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
