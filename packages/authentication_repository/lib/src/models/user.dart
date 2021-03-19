import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {

  final String email;
  final String id;
  final String name;
  final String photo;
  final bool isVerified;
  final String houseName;

  const User({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.photo,
    @required this.isVerified,
    @required this.houseName,
  }) : assert(email != null), assert(id != null), assert(isVerified != null);



  // unauthenticated user...
  static const empty = User(email: '', id: '', isVerified: false, name: null, photo: null, houseName: '');

  @override
  List<Object> get props => [email, id, isVerified, name, photo];

}