import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpDetailsScreen extends SourceConsumerStatefulWidget {
  const SignUpDetailsScreen({super.key});

  @override
  SourceConsumerState<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends SourceConsumerState<SignUpDetailsScreen> {
  final _displayNameFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required(), ValidatorsTyped.text(minLength: 5)],
  );

  @override
  void dispose() {
    _displayNameFb.dispose();
    super.dispose();
  }

  late final _signUp = ref.mutation(
    (ref, None _) async {
      await UsersRepository.instance.create(phoneNumber: null, displayName: _displayNameFb.value);
    },
    onError: (_, error) {
      CoreUtils.showErrorSnackBar(context, error);
    },
  );

  @override
  Widget build(BuildContext context) {
    final isIdle = !ref.watchIsMutating([_signUp]);
    final signUp = _displayNameFb.handleSubmit(() => _signUp(none));

    return Scaffold(
      appBar: AppBar(leading: const SignOutIconButton(), title: const Text('Sign Up!')),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? signUp : null,
              child: const Text('Viva Flutter!'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReactiveTextField(
              formControl: _displayNameFb,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
          ],
        ),
      ),
    );
  }
}
