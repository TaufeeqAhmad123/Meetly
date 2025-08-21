import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';

class WaitingApprovalScreen extends StatelessWidget {
  final String roomID;
  const WaitingApprovalScreen({super.key, required this.roomID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomID)
          .collection('waitingList')
          .where('status', isEqualTo: 'waiting')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users waiting to join'));
        }

        final data = snapshot.data!.docs;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'List of user waiting to join',
              style: GoogleFonts.inter(fontSize: 20),
            ),
          ),
          backgroundColor: kwhiteColor,
          body: data.isEmpty
              ? Scaffold(body: Center(child: Text('No users waiting to join')))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final user = data[index];
                    return ListTile(
                      title: Text(
                        user['name'],
                        style: GoogleFonts.inter(fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                               Navigator.pop(context);
                              data[index].reference.update({
                                'status': 'approved',
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check),
                          ),
                          IconButton(
                            onPressed: () {
                              data[index].reference.update({
                                'status': 'rejected',
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
