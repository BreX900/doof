import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class SignUpDetailsScreen extends ConsumerStatefulWidget {
  const SignUpDetailsScreen({super.key});

  @override
  ConsumerState<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends ConsumerState<SignUpDetailsScreen> {
  final _displayNameFb = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 5),
  );

  @override
  void dispose() {
    unawaited(_displayNameFb.close());
    super.dispose();
  }

  late final _signUp = ref.mutation((ref, arg) async {
    await UsersRepository.instance.create(
      phoneNumber: null,
      displayName: _displayNameFb.state.value,
    );
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watchIdle(mutations: [_signUp]);

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Sign Up!'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? ref.handleSubmit(_displayNameFb, () => _signUp(null)) : null,
              child: const Text('Viva Flutter!'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FieldText(
              fieldBloc: _displayNameFb,
              converter: FieldConvert.text,
              decoration: const InputDecoration(
                labelText: 'Display Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
