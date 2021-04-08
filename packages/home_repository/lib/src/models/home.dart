

import '../entities/entities.dart';



class Home {

  final homeName;
  final address;
  final creator;

  Home(this.homeName,this.address,this.creator);

  static Home fromEntity(HomeEntity entity) {
    return Home(
      entity.homeName,
      entity.address,
      entity.creator,
    );
  }



} 