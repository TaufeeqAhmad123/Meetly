import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/provider/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),

            userData.when(
              data: (data) {
                if (data == null) {
                  return const Center(child: Text("No user data found"));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data.image),
                    ),
                    Text(
                      data.name,
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data.email,
                      style: GoogleFonts.sarabun(
                        fontSize: 22,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ActionRowWidget(title: "Availability"),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey.shade400, height: 3),
                  ActionRowWidget(title: "Status"),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey.shade400, height: 3),
                  ActionRowWidget(title: "Work Location"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  rowWidget(
                    title: "Profile",
                    leadind: Icons.person,
                    traling: Icons.arrow_forward_ios,
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey.shade400, height: 3),
                  rowWidget(
                    title: "Profile",
                    leadind: Icons.person,
                    traling: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class rowWidget extends StatelessWidget {
  final String title;
  final IconData leadind, traling;
  const rowWidget({
    super.key,
    required this.title,
    required this.leadind,
    required this.traling,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(leadind),
        SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.sarabun(
            fontSize: 18,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(traling, size: 20),
          onPressed: () {
            // Handle edit profile action
          },
        ),
      ],
    );
  }
}

class ActionRowWidget extends StatefulWidget {
  final String title;
  const ActionRowWidget({super.key, required this.title});

  @override
  State<ActionRowWidget> createState() => _ActionRowWidgetState();
}

class _ActionRowWidgetState extends State<ActionRowWidget> {
  @override
  Widget build(BuildContext context) {
    List item = [
      'Available',
      'Away',
      'Busy',
      "Out of office",
      'Do Not Disturb',
    ];
    String? selectedStatus;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.sarabun(
            fontSize: 18,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 180,
          // control width of dropdown
          child: DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: item.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item),
                    if (selectedStatus == item)
                      const Icon(Icons.check, color: Colors.blue, size: 18),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
