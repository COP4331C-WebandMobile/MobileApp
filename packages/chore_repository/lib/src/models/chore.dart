import 'package:meta/meta.dart';
import '../entities/chore_entity.dart';
import 'package:equatable/equatable.dart';


@immutable
class Chore extends Equatable {
  final bool mark;
  final String id;
  final String description;
  final String creator;

  Chore(this.creator, this.mark, this.description,this.id);

  Chore copyWith({bool mark, String id, String description, String creator}) {
    return Chore(
      this.creator,
      this.mark,
      this.id,
      this.description,
    );
  }

  @override
  List<Object> get props => [mark, id, description, creator];



  ChoreEntity toEntity() {
    return ChoreEntity(creator, id, description, mark);
  }

  static Chore fromEntity(ChoreEntity entity) {
    return Chore(
      entity.creator,
      entity.mark,
      entity.description,
      entity.id,
    );
  }
}
