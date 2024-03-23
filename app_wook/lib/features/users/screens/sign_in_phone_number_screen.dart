import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/routes/routes.dart';
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';

class SignInPhoneNumberScreen extends ConsumerStatefulWidget {
  final String? verificationId;

  const SignInPhoneNumberScreen({
    super.key,
    this.verificationId,
  });

  @override
  ConsumerState<SignInPhoneNumberScreen> createState() => _SignInPhoneNumberScreenState();
}

class _SignInPhoneNumberScreenState extends ConsumerState<SignInPhoneNumberScreen> {
  final _phoneNumberFb = FieldBloc(initialValue: '');

  String? get _verificationId => widget.verificationId;

  final _sentCodeFb = FieldBloc(initialValue: '');

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) return;
    _phoneNumberFb.changeValue('+39 346 811 4956');
  }

  late final _signIn = ref.mutation((ref, arg) async {
    return await UsersProviders.signInWithPhoneNumber(ref, _phoneNumberFb.state.value);
  }, onSuccess: (_, verificationId) {
    final route = SignInPhoneNumberRoute(verificationId: verificationId);
    context.pushReplacement(route.location, extra: route);
  });

  late final _confirmVerification = ref.mutation((ref, arg) async {
    await UsersProviders.confirmPhoneNumberVerification(
      ref,
      _verificationId!,
      organizationId: Env.organizationId,
      code: _sentCodeFb.state.value,
    );
  });

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watchIdle(mutations: [_signIn, _confirmVerification]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle
                  ? (_verificationId == null
                      ? ref.handleSubmit(_phoneNumberFb, () => _signIn(null))
                      : ref.handleSubmit(_sentCodeFb, () => _confirmVerification(null)))
                  : null,
              child: const Text('Sign In'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final Widget content;
    if (_verificationId == null) {
      content = Column(
        children: [
          FieldText(
            fieldBloc: _phoneNumberFb,
            converter: FieldConvert.text,
            type: const TextFieldType.phoneNumber(),
          ),
        ],
      );
    } else {
      content = Column(
        children: [
          FieldText(
            fieldBloc: _sentCodeFb,
            converter: FieldConvert.text,
            type: const TextFieldType.integer(),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: content,
    );
  }
}
