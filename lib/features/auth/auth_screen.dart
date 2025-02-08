import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/theme/theme.dart';
import 'package:mission_leftoverlove_admin/features/auth/auth_controller.dart';
import 'package:mission_leftoverlove_admin/route/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthScreen extends ConsumerStatefulWidget {
  static const id = AppRoutes.authScreen;
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isSignUp = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 80.w,
          height: isSignUp ? 65.h : 50.h,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSignUp)
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              if (isSignUp)
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() => errorMessage = null);

                        if (isSignUp) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signUpOwner(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                                phoneNumber: phoneController.text.trim(),
                              );
                        } else {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signInOwner(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        }
                      },
                      child: Text(isSignUp ? "Sign Up" : "Sign In"),
                    ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isSignUp = !isSignUp;
                  });
                },
                child: Text(isSignUp
                    ? "Already have an account? Sign In"
                    : "Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
