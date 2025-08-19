// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

// class VideoConferencePage extends StatelessWidget {
//   final String conferenceID;

//   const VideoConferencePage({
//     Key? key,
//     required this.conferenceID,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
    
// // !mark(1:8)
//       child: ZegoUIKitPrebuiltVideoConference(
//         appID: YourAppID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign: YourAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: 'user_id',
//         userName: 'user_name',
//         conferenceID: conferenceID,
//         config: ZegoUIKitPrebuiltVideoConferenceConfig(),
//       ),

//     );
//   }
// }