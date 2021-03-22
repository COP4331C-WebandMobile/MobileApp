import 'package:meta/meta.dart';
import '../entities/chore_entity.dart';

@immutable
class Chore {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Chore(this.task, {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id;

  Chore copyWith({bool complete, String id, String note, String task}) {
    return Chore(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chore &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  @override
  String toString() {
    return 'Chore { complete: $complete, task: $task, note: $note, id: $id }';
  }

  ChoreEntity toEntity() {
    return ChoreEntity(task, id, note, complete);
  }

  static Chore fromEntity(ChoreEntity entity) {
    return Chore(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}
