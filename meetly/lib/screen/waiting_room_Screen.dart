import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/provider/approval_provider.dart';
import 'package:meetly/screen/meeting_room_screen.dart';
import 'package:meetly/widget/bouncing_dot.dart';
import 'package:meetly/widget/custom_button.dart';

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
    // ✅ Listen only for changes in approval state
    ref.listen(approvalProvider((roomId, userId)), (previous, next) {
      next.whenData((data) {
        final status = data?['status'];
        if (status == 'approved') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MeetingRoomScreen(
                name: data?['name'] ?? '',
                roomId: roomId,
                isMicOff: isMicoff,
                isCameraOff: iscameraOff,
                isHost: false,
              ),
            ),
          );
        } else if (status == 'rejected') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Your request has been rejected")),
          );
        }
      });
    });

    // ✅ Just watch to build UI
    final approvalState = ref.watch(approvalProvider((roomId, userId)));

    return approvalState.when(
      data: (data) {
        final status = data?['status'];
        if (status == 'rejected') {
          return Scaffold(
            backgroundColor: kwhiteColor,
            body: Column(
              children: [
                Center(
                  child: Text(
                    'Your request has been rejected',
                    style: GoogleFonts.inter(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                customButton(data: 'Go to home', onPressed: () {
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        }

        // Default waiting screen
        return Scaffold(
          backgroundColor: kwhiteColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your request is pending approval',
                style: GoogleFonts.inter(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const BouncingDotIndicator(),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
