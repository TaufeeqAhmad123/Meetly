class MeetingstateModel {
  final bool isMicOff;
  final bool isCameraOff;
  final String meetingId;

  MeetingstateModel( {
    required this.isMicOff,
    required this.isCameraOff,
    required this.meetingId,
  });
  MeetingstateModel copyWith({
    String? meetingId,
    bool? isMicOff,
    bool? isCameraOff,
  }) {
    return MeetingstateModel(
      meetingId: meetingId ?? this.meetingId,
      isMicOff: isMicOff ?? this.isMicOff,
      isCameraOff: isCameraOff ?? this.isCameraOff,
    );
  }

}