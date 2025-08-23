import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/core/utils/const/key.dart';
import 'package:meetly/provider/join_meeting_provider.dart';
import 'package:meetly/provider/meeting_provider.dart';
import 'package:meetly/provider/meeting_state_provider.dart';
import 'package:meetly/screen/waiting_approval_screen.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingRoomScreen extends ConsumerStatefulWidget {
  final String name, roomId;
  final bool isMicOff, isCameraOff, isHost;

  const MeetingRoomScreen({
    super.key,
    required this.name,
    required this.roomId,
    required this.isMicOff,
    required this.isCameraOff,
    required this.isHost,
  });

  @override
  ConsumerState<MeetingRoomScreen> createState() => _MeetingRoomScreenState();
}

class _MeetingRoomScreenState extends ConsumerState<MeetingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final elapsedTime = ref.watch(meetingRoomProvider).time;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .collection('waitingList')
              .where('status', isEqualTo: 'waiting')
              .snapshots(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.docs.length : 0;

            return Stack(
              children: [
                ZegoUIKitPrebuiltVideoConference(
                  appID: appKey,
                  appSign: appSignin,
                  userID: userId,
                  userName: widget.name,
                  conferenceID: widget.roomId,
                  config: ZegoUIKitPrebuiltVideoConferenceConfig()
                    ..turnOnCameraWhenJoining = !widget.isCameraOff
                    ..turnOnMicrophoneWhenJoining = !widget.isMicOff
                    ..layout = ZegoLayout.gallery(
                      addBorderRadiusAndSpacingBetweenView: false,
                    )
                    ..topMenuBarConfig = ZegoTopMenuBarConfig(
                      isVisible: true,
                      backgroundColor: Colors.transparent,
                      title: '',
                      buttons: [
                        ZegoMenuBarButtonName.switchCameraButton,
                        ZegoMenuBarButtonName.toggleScreenSharingButton,
                      ],
                      extendButtons: [
                        if (widget.isHost)
                          IconButton(
                            icon: Badge(
                              label: Text(count.toString()),
                              child: Icon(Icons.people, color: kwhiteColor),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WaitingApprovalScreen(
                                    roomID: widget.roomId,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    )
                    ..onLeave = () {
                      ZegoUIKit().leaveRoom();
                      ref.invalidate(meetingProvider);
                      ref.invalidate(meetingRoomProvider);
                      ref.invalidate(JoinmeetingProvider);
                      Navigator.pop(context);
                    }
                    ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                      maxCount: 6,
                      style: ZegoMenuBarStyle.light,

                      buttons: [
                        ZegoMenuBarButtonName.toggleMicrophoneButton,
                        ZegoMenuBarButtonName.toggleCameraButton,
                        ZegoMenuBarButtonName.leaveButton,
                        ZegoMenuBarButtonName.chatButton,
                      ],
                      extendButtons: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.only(
                                  right: 15,
                                  left: 7,
                                  top: 13,
                                  bottom: 13,
                                ),
                                backgroundColor: korangColor,
                                shape: CircleBorder(),
                              ),
                              icon: Icon(Icons.group, color: kwhiteColor),
                              onPressed: () async {
                                final roomData = await FirebaseFirestore
                                    .instance
                                    .collection('room')
                                    .doc(widget.roomId)
                                    .get();
                                final hostId = roomData['hostid'] ?? "";
                                final allUsers = ZegoUIKit().getAllUsers();
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: kblackColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                ),

                if (widget.isHost)
                  Positioned(
                    top: 16,
                    left: 20,
                    child: Text(
                      'Meeting ID: ${widget.roomId}   $elapsedTime ',
                      style: GoogleFonts.inter(
                        color: kwhiteColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(String hostid, List<ZegoUIKitUser> currentUser) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: kwhiteColor,
                  size: 30,
                ),
              ),
              SizedBox(width: 20),
              Text(
                "Members : ${ZegoUIKit().getAllUsers().length.toString()}",
                style: GoogleFonts.inter(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: kwhiteColor,
                ),
              ),
            ],
          ),
          Divider(color: Colors.black38),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: ZegoUIKit().getUserListStream(),
              initialData: currentUser,
              builder: (_, snapshot) {
                final participent = snapshot.data ?? [];
                if (participent.isEmpty) {
                  return Center(child: Text("No participants"));
                }
                return ListView.builder(
                  itemCount: participent.length,
                  itemBuilder: (context, index) {
                    final user = participent[index];
                    final isHost = user.id == hostid;
                    return ListTile(
                      leading: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(user.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData) {
                            return Icon(Icons.error);
                          }
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                     String? photoUrl = userData['photoURL'];
                          if (photoUrl == null &&
                              user.id ==
                                  FirebaseAuth.instance.currentUser?.uid) {
                            photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
                            
                          }
                          return CircleAvatar(
                            backgroundColor: kblueColor,
                           backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl)
                                : AssetImage('assets/images/user.png')
                                    as ImageProvider,
                            radius: 20,
                          );
                        },
                      ),
                      title: Text(
                        user.name,
                        style: GoogleFonts.inter(
                          color: kwhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: isHost
                          ? Text(
                              'Host',
                              style: GoogleFonts.inter(
                                color: korangColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : null,
                      trailing: isHost
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                ref
                                    .read(meetingRoomProvider.notifier)
                                    .removeUser(user);
                              },
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
