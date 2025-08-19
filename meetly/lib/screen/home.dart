import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/provider/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: userData.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text("No user data found"));
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name: ${user.name}"),
                  Text("Bio: ${user.bio}"),
                  Text("Bio: ${user.userName}"),
                  Text("Email: ${user.email}"),
                  Text("UID: ${user.uid}"),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.image),
                  )
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
