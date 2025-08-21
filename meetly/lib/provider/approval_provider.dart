import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final approvalProvider =
    StreamProvider.family<
      Map<String, dynamic>?,
      (String roomId, String userId)
    >((ref, arg) {
      final (roomId, userId) = arg;
      return FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('waitingList')
          .doc(userId)
          .snapshots()
          .map((doc) => doc.data());
    });
