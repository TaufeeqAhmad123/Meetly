class MeetingState {
  final String time;

  MeetingState({required this.time});

  MeetingState copyWith({String? time}) {
    return MeetingState(time: time ?? this.time);
  }
}
