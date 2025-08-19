import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/core/utils/snackbar/snakbar.dart';
import 'package:meetly/provider/auth_provider.dart';
import 'package:meetly/screen/home.dart';
import 'package:meetly/widget/navbar.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final authRepo = ref.read(authRepositoryProvider);
              final user = await authRepo.SiginWithGoogle();
              print(user);
              if (user != null) {
                // Navigate to home screen
                ShowSnackbar(
                  context: context,
                  type: SnackBarType.success,
                  message: 'Signup successful',
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavbarWidget()),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              fixedSize: Size(370, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            child: const Text('Signup With Google'),
          ),
        ],
      ),
    );
  }
}
