import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/provider/meeting_provider.dart';
import 'package:meetly/widget/custom_button.dart';

class NewmeetingScreen extends ConsumerStatefulWidget {
  const NewmeetingScreen({super.key});

  @override
  ConsumerState<NewmeetingScreen> createState() => _NewmeetingScreenState();
}

class _NewmeetingScreenState extends ConsumerState<NewmeetingScreen> {
  late TextEditingController _meetingIdController;
  late TextEditingController _nameController;

  @override
  void initState() {
    final meetingState = ref.read(meetingProvider);
    _nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName ?? '',
    );
    _meetingIdController = TextEditingController(text: meetingState.meetingId);
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
  Widget build(BuildContext context) {
    final meetingState = ref.watch(meetingProvider);
    return Scaffold(
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
                  color: const Color.fromARGB(255, 9, 121, 213),
                ),
              ),
            ),
            SizedBox(width: 25),
            Text(
              'Start a meeting',
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
              // controller: _meetingIdController,
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Meeting Id : ${_meetingIdController.text}",
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
              enabled: false, // keeps it disabled
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
          SwitchListTile(
            activeColor: Colors.green,
            inactiveThumbColor: Colors.black,
            activeThumbColor: Colors.green,
            value: meetingState.isMicOff,
            onChanged: (value) {
              ref.read(meetingProvider.notifier).toggleMic(value);
            },
          ),
          SwitchListTile(
            activeColor: Colors.green,
            inactiveThumbColor: Colors.black,
            activeThumbColor: Colors.green,
            value: meetingState.isCameraOff,
            onChanged: (value) {
              ref.read(meetingProvider.notifier).toggleCamera(value);
            },
          ),
          SizedBox(height: 20),
          CustomButton(
            data: 'Start a Meeting',
            onPressed: () {
              // Start the meeting
            },
          ),
        ],
      ),
    );
  }
}
