import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetly/core/utils/const/key.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
class MeetingRoomScreen extends StatefulWidget {
  final String name,roomId;
  final bool isMicOff,isCameraOff,isHost;

  const MeetingRoomScreen({super.key, required this.name, required this.roomId, required this.isMicOff, required this.isCameraOff, required this.isHost});

  @override
  State<MeetingRoomScreen> createState() => _MeetingRoomScreenState();
}

class _MeetingRoomScreenState extends State<MeetingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final userId=FirebaseAuth.instance.currentUser?.uid ?? '';
    return  Scaffold(
      body: SafeArea(
       child: ZegoUIKitPrebuiltVideoConference(
        appID: appKey, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: appSignin, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: widget.name,
        conferenceID: widget.roomId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig()..turnOnCameraWhenJoining = !widget.isCameraOff..turnOnMicrophoneWhenJoining = !widget.isMicOff,
      ),
      ),
    );
  }
}