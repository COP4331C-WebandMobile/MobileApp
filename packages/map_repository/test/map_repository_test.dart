import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_repository/map_repository.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

const uid = 'abc';
const houseName = "Home";

main() {

  final instance = MockFirestoreInstance();

  const expectedDumpAfterset = '''{
  "users": {
    "abc": {
      "name": "Bob"
    }
  }
}''';

  final time = Timestamp.now();
  const location = GeoPoint(45, 45);
  

    instance.collection('locations').doc(houseName).collection('location').add(
    {
      "lastKnownTime": time,
      "location": location,
    }
  );

  
  test('Sets data for a document within a collection', () async {

    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    expect(instance.dump(), equals(expectedDumpAfterset));
  });

  test("Location Test Failure", () async {

    String address = "1259";
    
    List<HouseLocation> result = await MapRepository(firestore: instance, houseName: houseName).fetchAdresses(address);

    expect(result, Exception());
  });
}
