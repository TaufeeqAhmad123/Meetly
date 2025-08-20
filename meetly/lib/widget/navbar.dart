import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetly/screen/home.dart';
import 'package:meetly/screen/join_meeting_screen.dart';
import 'package:meetly/screen/profile_screen.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);

class NavbarWidget extends ConsumerWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider);

    final List<Widget> pages = [
      HomeScreen(),
      JoinMeetingScreen(),
      HomeScreen(),
      ProfileScreen(),
    ];

    final List<String> icons = [
      "assets/icon/home.svg",
      "assets/icon/chat.svg",
      "assets/icon/setting.svg",
      "assets/icon/user.svg",
    ];

    return Scaffold(
      body: pages[selectedIndex], // 👈 switch pages here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state =
              index; // 👈 updates screen
        },
        items: List.generate(icons.length, (index) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              icons[index],
              color: selectedIndex == index ? Colors.black : Colors.grey,
              width: 28,
              height: 28,
            ),
            label: "",
          );
        }),
      ),
    );
  }
}
