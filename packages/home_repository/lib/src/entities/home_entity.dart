import 'package:cloud_firestore/cloud_firestore.dart';


class HomeEntity {

  final creator;
  final homeName;
  final address;

  const HomeEntity(this.creator,this.homeName,this.address);

  static HomeEntity fromSnapshot(DocumentSnapshot snap) {
    print(snap.data()["house_name"]);
    return HomeEntity(
      snap.data()["creator"],
      snap.data()['house_name'],
      snap.data()['address'],
     
    );
  }


}

