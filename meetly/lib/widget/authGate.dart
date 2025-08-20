import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/provider/auth_provider.dart';

import 'package:meetly/screen/signup.dart';
import 'package:meetly/widget/navbar.dart';

class Authgate extends ConsumerWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authState=ref.read(authStateChaneProvider);
    return  Scaffold(
      body: authState.when(data: (user){
          if(user!=null){
            return NavbarWidget();
          }else{
            return SignupScreen();
          }
        },
         loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
         ),
    );
  }
}