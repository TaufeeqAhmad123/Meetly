import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';
import 'package:meetly/core/utils/const/image.dart';
import 'package:meetly/provider/auth_provider.dart';
import 'package:meetly/screen/join_meeting_screen.dart';
import 'package:meetly/screen/newMeeting_screen.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> data = [
    {'title': 'Call', 'icon': callIcon, 'screen': NewmeetingScreen()},
    {'title': 'Join', 'icon': addIcon, 'screen': JoinMeetingScreen()},
    {'title': 'Schedule', 'icon': calendarIcon, 'screen': NewmeetingScreen()},
    {'title': 'Share', 'icon': shareIcon, 'screen': NewmeetingScreen()},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20, ),
              child: Row(
                children: [
                  userData.when(
                    data: (user) {
                      return user != null
                          ? CircleAvatar(
                            radius: 30,
                              backgroundImage: NetworkImage(user.image),
                            )
                          : const SizedBox.shrink();
                    },
                    loading: () =>
                        Center(child: const CircularProgressIndicator()),
                    error: (err, _) => const Icon(Icons.error),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Home',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(data.length, (index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => data[index]['screen'],
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),

                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: index == 0 ? korangColor : kblueColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            data[index]['icon'],
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        data[index]['title'],
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
