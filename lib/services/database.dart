// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brew_crew/model/brew.dart';
import 'package:brew_crew/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    required this.uid,
  });

  final brewsCollection = FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewsCollection
        .doc(uid)
        .set({"sugars": sugars, "name": name, "strength": strength});
  }

  //create brew object according to my custom brew class based on the QuerySnapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map;
      return Brew(
          sugars: data["sugars"] ?? "0",
          name: data["name"] ?? "",
          strength: data["strength"] ?? 100);
    }).toList();
  }

// i need to call the above function every time I get a snapshot (doc) of the collection
  Stream<List<Brew>> get brews {
    return brewsCollection.snapshots().map(_brewListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    return UserData(
        uid: uid,
        name: data["name"],
        sugar: data["sugars"],
        strength: data["strength"]);
  }

// i need to call the above function every time I get a snapshot (date) of the doc of the collection
  Stream<UserData> get userData {
    return brewsCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
