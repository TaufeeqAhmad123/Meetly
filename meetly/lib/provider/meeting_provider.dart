import 'package:meetly/model/meetingState_model.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:math';

final meetingProvider =
    StateNotifierProvider.autoDispose<MeetingNotifier, MeetingstateModel>((
      ref,
    ) {
      return MeetingNotifier();
    });

class MeetingNotifier extends StateNotifier<MeetingstateModel> {
  MeetingNotifier()
    : super(
        MeetingstateModel(
          meetingId: Random().nextInt(1000000).toString(),
          isMicOff: false,
          isCameraOff: false,
        ),
      );

  MeetingstateModel get meetingState => state;
  void toggleMic(bool value) {
    state = state.copyWith(isMicOff: value);
  }

  void toggleCamera(bool value) {
    state = state.copyWith(isCameraOff: value);
  }

  void updateMeetingState(MeetingstateModel newState) {
    state = newState;
  }
}
