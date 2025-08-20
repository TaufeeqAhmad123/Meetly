import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/model/join_meeting_model.dart';

final JoinmeetingProvider =
    StateNotifierProvider.autoDispose<JoinMeetingNotifier, JoinMeetingModel>((
      ref,
    ) {
      return JoinMeetingNotifier();
    });

class JoinMeetingNotifier extends StateNotifier<JoinMeetingModel> {
  JoinMeetingNotifier()
    : super(JoinMeetingModel(isMicOff: false, isCameraOff: false,error: null));

  JoinMeetingModel get meetingState => state;
  void toggleMic(bool value) {
    state = state.copyWith(isMicOff: value);
  }

  void toggleCamera(bool value) {
    state = state.copyWith(isCameraOff: value);
  }

  void setError(String? message) {
    state = state.copyWith(error: message);
  }

  void updateMeetingState(JoinMeetingModel newState) {
    state = newState;
  }
}
