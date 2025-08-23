import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/model/metting_state.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingRoomNotifier extends StateNotifier<MeetingState> {
  MeetingRoomNotifier() : super(MeetingState(time: "00:00")) {
    _startTimer();
  }
  late final Timer _timer;
  late final Stopwatch _stopwatch;
  void _startTimer() {
    _stopwatch = Stopwatch();
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final elapsed = _stopwatch.elapsed;
      final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
      state = state.copyWith(time: "$minutes:$seconds");
    });
  }


  void removeUser(ZegoUIKitUser user){
    ZegoUIKit().removeUserFromRoom([user.id]);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _stopwatch.stop();
  }
}


final meetingRoomProvider = StateNotifierProvider<MeetingRoomNotifier, MeetingState>((ref) {
  return MeetingRoomNotifier();
});