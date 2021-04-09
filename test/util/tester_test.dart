import 'package:flutter_test/flutter_test.dart';
import 'package:map_repository/map_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const uid = 'abc';
main() {
  const expectedDumpAfterset = '''{
  "users": {
    "abc": {
      "name": "Bob"
    }
  }
}''';

  test('Sets data for a document within a collection', () async {
    final instance = MockFirestoreInstance();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    expect(instance.dump(), equals(expectedDumpAfterset));
  });

  test("Location Test Failure", () async {
    String address = "1259";

    List<HouseLocation> result = await MapRepository().fetchAdresses(address);

    expect(result, Exception());
  });
}
