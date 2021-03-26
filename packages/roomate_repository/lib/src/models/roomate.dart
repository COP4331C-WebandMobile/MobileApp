
import '../entities/entities.dart';

class Roomate{

  final firstName;
  final lastName;
  final email;
  final phoneNumber;
  final lastLocation;
 

  Roomate(this.firstName,this.lastName,this.email, this.phoneNumber, this.lastLocation);

  static Roomate fromEntity(RoomateEntity entity) {
    return Roomate(
      entity.firstName,
      entity.lastName,
      entity.email,
      entity.phoneNumber,
      entity.lastLocation,
    );
  }

} 