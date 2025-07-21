// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveTaskAdapter extends TypeAdapter<SaveTask> {
  @override
  final int typeId = 0;

  @override
  SaveTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveTask(
      task: fields[0] as String,
      time: fields[1] as DateTime,
      note: fields[2] as String?,
      isDone: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SaveTask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
