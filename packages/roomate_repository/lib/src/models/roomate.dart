
import '../entities/entities.dart';

class Roomate{

  final firstName;
  final lastName;
  final email;
  final phoneNumber;
  final lastLocation;
 

  Roomate(this.firstName,this.lastName,this.email, this.phoneNumber, this.lastLocation);

  static Roomate fromEntity(email, RoomateEntity entity) {
    return Roomate(
      entity.firstName,
      entity.lastName,
      email,
      entity.phoneNumber,
      entity.lastLocation,
    );
  }

   Map<String, Object> toDocument() {
    return {
      "email":email,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
  
    };
  }

} 