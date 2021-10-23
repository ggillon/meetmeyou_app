import 'package:cloud_firestore/cloud_firestore.dart';

List<String> genCases(String s) {
  List<String> strings = [];
  strings.add(s);
  strings.add(s.toLowerCase());
  strings.add(s.substring(0,1).toUpperCase() + s.substring(1).toLowerCase());

  return strings;
}

class FirestoreService {

  // Singleton constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  // Generic functions user in other methods
  Future<void> setData({required String path, required Map<String, dynamic> data}) async {
    final docRef = FirebaseFirestore.instance.doc(path);
    await docRef.set(data);
  }

  Future<T> getData<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) async {
    final docRef = FirebaseFirestore.instance.doc(path);
    final snapshot = await docRef.get();
    return builder(snapshot.data()!);
  }

  Future<List<T>> getListData<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) async {
    final docRef = FirebaseFirestore.instance.collection(path);
    final snapshots = await docRef.get();
    return snapshots.docs.map((snapshot) => builder(snapshot.data())).toList();
  }

  Future<List<T>> getListDataWhere<T>({
    required String path,
    required String field,
    required String value,
    required T Function(Map<String, dynamic> data) builder,
  }) async {

    List<String> values = genCases(value);

    final docRef = FirebaseFirestore.instance.collection(path).where(field, whereIn: values);
    final snapshots = await docRef.get();
    return snapshots.docs.map((snapshot) => builder(snapshot.data())).toList();
  }


  Future<void> deleteData({required String path,}) async {
    final docRef = FirebaseFirestore.instance.doc(path);
    await docRef.delete();
  }

  Future<void> deleteCollection({required String path,}) async {
    FirebaseFirestore.instance.collection(path).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs)
      {
        ds.reference.delete();
      }}
    );
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final docRef = FirebaseFirestore.instance.collection(path);
    final snapshots = docRef.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
            (snapshot) => builder(snapshot.data())
    ).toList()
    );
  }

  Stream<List<T>> collectionStreamWhereFieldPresent<T>({
    required String path,
    required String field,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final docRef = FirebaseFirestore.instance.collection(path).where(field, isNotEqualTo: '');
    final snapshots = docRef.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
            (snapshot) => builder(snapshot.data())
    ).toList()
    );
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final docRef = FirebaseFirestore.instance.doc(path);
    final snapshots = docRef.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()!)
    );
  }

}