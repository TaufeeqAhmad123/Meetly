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
                  Text("Name: ${user.name}",style: TextStyle(fontFamily: "Mont",fontWeight: FontWeight.bold,fontSize: 22),),
                  Text("Bio: ${user.bio}",style: TextStyle(fontFamily: "Mont"),),
                  Text("Bio: ${user.userName}",style: TextStyle(fontFamily: "Mont"),),
                  Text("Email: ${user.email}",style: TextStyle(fontFamily: "Mont"),),
                  Text("UID: ${user.uid}",style: TextStyle(fontFamily: "Mont"),),
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
