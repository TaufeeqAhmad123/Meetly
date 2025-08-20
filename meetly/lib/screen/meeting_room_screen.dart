import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/core/utils/const/key.dart';
import 'package:meetly/screen/waiting_approval_screen.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingRoomScreen extends StatefulWidget {
  final String name, roomId;
  final bool isMicOff, isCameraOff, isHost;

  const MeetingRoomScreen({
    super.key,
    required this.name,
    required this.roomId,
    required this.isMicOff,
    required this.isCameraOff,
    required this.isHost,
  });

  @override
  State<MeetingRoomScreen> createState() => _MeetingRoomScreenState();
}

class _MeetingRoomScreenState extends State<MeetingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .collection('waitingList')
              .where('status', isEqualTo: 'waiting')
              .snapshots(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.docs.length : 0;

            return ZegoUIKitPrebuiltVideoConference(
              appID: appKey,
              appSign: appSignin,
              userID: userId,
              userName: widget.name,
              conferenceID: widget.roomId,
              config: ZegoUIKitPrebuiltVideoConferenceConfig()
                ..turnOnCameraWhenJoining = !widget.isCameraOff
                ..turnOnMicrophoneWhenJoining = !widget.isMicOff
                ..layout = ZegoLayout.gallery(
                  addBorderRadiusAndSpacingBetweenView: false,
                )
                ..topMenuBarConfig = ZegoTopMenuBarConfig(
                  isVisible: true,
                  backgroundColor: Colors.transparent,
                  title: '',
                  buttons: [
                    ZegoMenuBarButtonName.switchCameraButton,
                    ZegoMenuBarButtonName.toggleScreenSharingButton,
                  ],
                  extendButtons: [
                    if (widget.isHost)
                      IconButton(
                        icon: Badge(
                          label: Text(count.toString()),
                          child: Icon(Icons.people, color: kwhiteColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WaitingApprovalScreen(roomID: widget.roomId),
                            ),
                          );
                        },
                      ),
                  ],
                ),
            );
          },
        ),
      ),
    );
  }
}
