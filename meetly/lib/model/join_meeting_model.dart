class JoinMeetingModel {
  final bool isMicOff;
  final bool isCameraOff;
  final String? error;

  JoinMeetingModel( {
    required this.isMicOff,
    required this.isCameraOff,
     this.error,
  });
  JoinMeetingModel copyWith({
    String? error,
    bool? isMicOff,
    bool? isCameraOff,
  }) {
    return JoinMeetingModel(
      error: error,
      isMicOff: isMicOff ?? this.isMicOff,
      isCameraOff: isCameraOff ?? this.isCameraOff,
    );
  }

}