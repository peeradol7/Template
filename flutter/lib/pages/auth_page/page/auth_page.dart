import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../model/create_user_request.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Auth Page')),
      body: state.isLoading || state.isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.errMsg != null)
                    Text(
                      state.errMsg!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (state.currentUser != null)
                    Text('Logged in as: ${state.currentUser!.username}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.createUser(const CreateUserRequest(
                        username: 'testuser',
                        email: 'test@example.com',
                        password: 'password123',
                      ));
                    },
                    child: const Text('Create Dummy User'),
                  ),
                ],
              ),
            ),
    );
  }
}
