import 'package:meta/meta.dart';
import '../entities/chore_entity.dart';
import 'package:equatable/equatable.dart';


@immutable
class Chore extends Equatable {
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
  List<Object> get props => [complete, id, note, task];


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
