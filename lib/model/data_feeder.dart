import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:successhunter/model/diary.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

class DataFeeder {
  String mainCollectionId = '';

  static final DataFeeder _singleton = DataFeeder._internal();

  DataFeeder._internal();

  static DataFeeder get instance => _singleton;

  void setCollectionId(String uid) {
    mainCollectionId = uid;
  }

  initializeDatabase() async {
    final TransactionHandler createTransaction =
        (Transaction transaction) async {
      final DocumentSnapshot documentSnapshot = await transaction.get(Firestore
          .instance
          .collection(mainCollectionId)
          .document('goals')
          .collection('goals')
          .document());
      var initGoal = Goal(
        title: 'Sample goal',
        targetDate: DateTime.parse('20190112'),
        currentValue: 40,
        type: ActivityTypeEnum.career,
        milestones: <Milestone>[
          Milestone(
            title: 'First milestone',
            targetValue: 20,
            targetDate: DateTime.parse('20181108'),
          ),
        ],
      );

      print('${json.decode(json.encode(initGoal))}');
      await transaction.set(
          documentSnapshot.reference, json.decode(json.encode(initGoal)));

      return initGoal.toJson();
    };

    return Firestore.instance.runTransaction(createTransaction).catchError(
      (error) {
        print('error: $error');
        return null;
      },
    );
  }

  /// Goal Section
  addNewGoal(Goal item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .document();
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  overwriteGoal(String documentId, Goal item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .document(documentId);
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  Stream<QuerySnapshot> getDoingGoalList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .where('state', isEqualTo: 0)
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Stream<QuerySnapshot> getGoalList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .orderBy('state')
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Stream<DocumentSnapshot> getGoal(String documentId) {
    Stream<DocumentSnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .document(documentId)
        .snapshots();

    return snapshots;
  }

  deleteGoal(String documentId) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('goals')
        .collection('goals')
        .document(documentId);
    batch.delete(docRef);

    await batch.commit().catchError((error) => print('error: $error'));
  }

  /// Habit section
  void addNewHabit(Habit item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .document();
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  void overwriteHabit(String documentId, Habit item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .document(documentId);
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  Stream<QuerySnapshot> getTodayHabitList() {
    return Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .where('state', isEqualTo: 0)
        .snapshots();
  }

  Stream<QuerySnapshot> getHabitList() {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .orderBy('state')
        .snapshots();

    return snapshots;
  }

  Stream<DocumentSnapshot> getHabit(String documentId) {
    Stream<DocumentSnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .document(documentId)
        .snapshots();

    return snapshots;
  }

  void deleteHabit(String documentId) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('habits')
        .collection('habits')
        .document(documentId);
    batch.delete(docRef);

    await batch.commit().catchError((error) => print('error: $error'));
  }

  // Diary Section
  void addNewDiary(Diary item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('diaries')
        .collection('diaries')
        .document();
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  void overwriteDiary(String documentId, Diary item) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('diaries')
        .collection('diaries')
        .document(documentId);
    batch.setData(docRef, json.decode(json.encode(item)));

    await batch.commit().catchError((error) => print('error: $error'));
  }

  Stream<QuerySnapshot> getDairyList() {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('diaries')
        .collection('diaries')
        .snapshots();

    return snapshots;
  }

  Stream<DocumentSnapshot> getDairy(String documentId) {
    Stream<DocumentSnapshot> snapshots = Firestore.instance
        .collection(mainCollectionId)
        .document('diaries')
        .collection('diaries')
        .document(documentId)
        .snapshots();

    return snapshots;
  }

  void deleteDiary(String documentId) async {
    var batch = Firestore.instance.batch();
    DocumentReference docRef = Firestore.instance
        .collection(mainCollectionId)
        .document('diaries')
        .collection('diaries')
        .document(documentId);
    batch.delete(docRef);

    await batch.commit().catchError((error) => print('error: $error'));
  }
}
