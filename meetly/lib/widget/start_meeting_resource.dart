import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/provider/meeting_provider.dart';
import 'package:meetly/screen/meeting_room_screen.dart';

void StartMeeting(
  WidgetRef ref,
  BuildContext context,
  TextEditingController name,
) async {
  final meetingState = ref.read(meetingProvider);

  final currentUser = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection('rooms')
      .doc(meetingState.meetingId)
      .set({
        'CreatedBy': currentUser?.uid,
        'hostid': currentUser?.uid ?? '',

        'hostName': currentUser?.displayName ?? '',

        'createdAt': FieldValue.serverTimestamp(),
        'meetingId': meetingState.meetingId,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingRoomScreen(
            name: name.text,
            roomId: meetingState.meetingId,
            isMicOff: meetingState.isMicOff,
            isCameraOff: meetingState.isCameraOff,
            isHost: true,
          ),
        ),
      );
}
