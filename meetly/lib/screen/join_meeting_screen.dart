import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/provider/join_meeting_provider.dart';
import 'package:meetly/provider/meeting_provider.dart';
import 'package:meetly/widget/custom_button.dart';
import 'package:meetly/widget/start_meeting_resource.dart';

class JoinMeetingScreen extends ConsumerStatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  ConsumerState<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends ConsumerState<JoinMeetingScreen> {
    late TextEditingController _meetingIdController;
  late TextEditingController _nameController;

  @override
  void initState() {
    final meetingState = ref.read(meetingProvider);
    _nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName ?? '',
    );
    _meetingIdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _meetingIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context,) {
    final state=ref.watch(JoinmeetingProvider);
    final notifier=ref.read(JoinmeetingProvider.notifier);
    return  Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: kblueColor,
                ),
              ),
            ),
            SizedBox(width: 25),
            Text(
              'Join a meeting',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
        body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: TextField(
              controller: _meetingIdController,
            
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                error: state.error != null
                    ? Text(
                        state.error!,
                        style: TextStyle(color: Colors.red),
                      )
                    : null,
                hintText: "Meeting Id : ",
                hintStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
                filled: true,
                fillColor: Colors.green.withAlpha(50),

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
           // keeps it disabled
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
                filled: true,
                fillColor: Colors.green.withAlpha(50),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          customButton(
            data: 'Join Meeting',
            onPressed: () {
              joinMeeting(ref, context, _nameController, _meetingIdController);
            },
          ),
          SizedBox(height: 20),
          SwitchListTile(
            title: Text(
              "Don't connect to audio",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            activeColor: korangColor,
            inactiveThumbColor: korangColor,
            activeThumbColor: korangColor,
            value: state.isMicOff,
            onChanged: notifier.toggleMic
          ),

          SwitchListTile(
            title: Text(
              'Turn off my video',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            activeColor: korangColor,
            inactiveThumbColor: korangColor,
            activeThumbColor: korangColor,
            value: state.isCameraOff,
            onChanged:notifier.toggleCamera
          ),
          SizedBox(height: 20),
          
        ],
      ),
    );
  }
}