import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataFeeder {
  String mainCollectionId;

  static final DataFeeder _singleton = DataFeeder._internal();
  DataFeeder._internal();
  static DataFeeder get instance => _singleton;

  void changeCollectionId(String uid) {
    mainCollectionId = uid;
  }
}