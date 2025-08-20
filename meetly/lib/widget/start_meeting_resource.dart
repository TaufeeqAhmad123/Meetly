import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/core/utils/snackbar/snakbar.dart';
import 'package:meetly/provider/join_meeting_provider.dart';
import 'package:meetly/provider/meeting_provider.dart';
import 'package:meetly/screen/meeting_room_screen.dart';
import 'package:meetly/screen/waiting_room_Screen.dart';

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

void joinMeeting(
  WidgetRef ref,
  BuildContext context,
  TextEditingController nameController,
  TextEditingController meetingIDController,
) async {
  final meetingID = meetingIDController.text;
  final name = nameController.text;
  final state = ref.read(JoinmeetingProvider);
  final notifier = ref.read(JoinmeetingProvider.notifier);

  final currentUser = FirebaseAuth.instance.currentUser;

  if (meetingID.isEmpty || name.isEmpty) {
    notifier.setError('Please fill in all fields');
    return;
  }

  final doc = await FirebaseFirestore.instance
      .collection('rooms')
      .doc(meetingID)
      .get();

  if (!doc.exists) {
    notifier.setError('Meeting Id not found');
    ShowSnackbar(
      context: context,
      type: SnackBarType.error,
      message: 'Meeting Id not found',
    );
    return;
  }

  await FirebaseFirestore.instance
      .collection('rooms')
      .doc(meetingID)
      .collection('waitingList').doc(currentUser?.uid).set({'name': name, 'status': 'waiting'});

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WaitingRoomScreen(
        roomId: meetingID,
        userId: currentUser?.uid ?? '',
        isMicoff: state.isMicOff,
        iscameraOff: state.isCameraOff,
      ),
    ),
  );
   ShowSnackbar(
      context: context,
      type: SnackBarType.success,
      message: 'Successfully joined the meeting',
    );
}
