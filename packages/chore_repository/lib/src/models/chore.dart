import 'package:meta/meta.dart';
import '../entities/chore_entity.dart';
import 'package:equatable/equatable.dart';


@immutable
class Chore extends Equatable {
  final bool mark;
  final String id;
  final String description;
  final String creator;

  Chore(this.creator, {this.mark = false, String description = '', String id})
      : this.description = description ?? '',
        this.id = id;

  Chore copyWith({bool mark, String id, String description, String creator}) {
    return Chore(
      creator ?? this.creator,
      mark: mark ?? this.mark,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  List<Object> get props => [mark, id, description, creator];


  @override
  String toString() {
    return 'Chore { mark: $mark, creator: $creator, description: $description, id: $id }';
  }

  ChoreEntity toEntity() {
    return ChoreEntity(creator, id, description, mark);
  }

  static Chore fromEntity(ChoreEntity entity) {
    return Chore(
      entity.creator,
      mark: entity.mark ?? false,
      description: entity.description,
      id: entity.id,
    );
  }
}
