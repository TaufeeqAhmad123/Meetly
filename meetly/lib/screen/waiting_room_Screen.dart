import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/provider/approval_provider.dart';
import 'package:meetly/screen/meeting_room_screen.dart';
import 'package:meetly/widget/bouncing_dot.dart';

class WaitingRoomScreen extends ConsumerWidget {
  final String userId;
  final String roomId;
  final bool isMicoff, iscameraOff;
  const WaitingRoomScreen({
    super.key,
    required this.userId,
    required this.roomId,
    required this.isMicoff,
    required this.iscameraOff,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalState = ref.watch(
      approvalProvider((roomId, userId )),
    );
    return approvalState.when(
      data: (data) {
        final status = data?['status'];
        if (status == 'approved') {
          WidgetsBinding.instance.addPersistentFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeetingRoomScreen(
                  name: data?['name'] ?? '',
                  roomId: roomId,
                  isMicOff: isMicoff,
                  isCameraOff: iscameraOff,
                  isHost: false,
                ),
              ),
            );
          });
        } else if (status == 'rejected') {
          return Scaffold(
            backgroundColor: kwhiteColor,
            body: Center(child: Text('Your request has been rejected')),
          );
        }
        return Scaffold(
          backgroundColor: kwhiteColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Your request is pending approval',
                  style: GoogleFonts.inter(fontSize: 18),
                ),
              ),
              SizedBox(height: 10,),
              BouncingDotIndicator(),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
