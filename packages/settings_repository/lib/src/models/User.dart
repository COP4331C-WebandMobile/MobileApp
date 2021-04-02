import '../entities/entities.dart';


class User {

  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;


  const User(this.email,this.phoneNumber,this.firstName,this.lastName);


  static User fromEntity(UserEntity entity) {
    return User(
      entity.email,
      entity.phoneNumber,
      entity.firstName,
      entity.lastName,
    
    );
  }

  UserEntity toEntity() {
    return UserEntity(firstName,lastName,email,phoneNumber);
  }



  // unauthenticated user...
}