import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:successhunter/model/goal.dart';
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
        type: GoalTypeEnum.career,
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

  addNewGoal(Goal item) async {
    final TransactionHandler createTransaction =
        (Transaction transaction) async {
      final DocumentSnapshot documentSnapshot = await transaction.get(Firestore
          .instance
          .collection(mainCollectionId)
          .document('goals')
          .collection('goals')
          .document());

      var initGoal = item;

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

  overwriteGoal(String documentId, Goal item) async {
    final TransactionHandler createTransaction =
        (Transaction transaction) async {
      final DocumentSnapshot documentSnapshot = await transaction.get(Firestore
          .instance
          .collection(mainCollectionId)
          .document('goals')
          .collection('goals')
          .document(documentId));

      var initGoal = item;

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
    final TransactionHandler deleteTransaction =
        (Transaction transaction) async {
      final DocumentSnapshot documentSnapshot = await transaction.get(Firestore
          .instance
          .collection(mainCollectionId)
          .document('goals')
          .collection('goals')
          .document(documentId));

      await transaction.delete(documentSnapshot.reference);
    };

    return Firestore.instance.runTransaction(deleteTransaction).catchError(
      (error) {
        print('error: $error');
        return false;
      },
    );
  }
}
