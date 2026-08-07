import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';

class SignInPhoneNumberScreen extends ConsumerStatefulWidget {
  final String? organizationId;
  final String? verificationId;
  final bool shouldPop;

  const SignInPhoneNumberScreen({
    super.key,
    required this.organizationId,
    required this.verificationId,
    required this.shouldPop,
  });

  @override
  ConsumerState<SignInPhoneNumberScreen> createState() => _SignInPhoneNumberScreenState();
}

class _SignInPhoneNumberScreenState extends ConsumerState<SignInPhoneNumberScreen> {
  late final _mutation = MutationController(ref);

  final _phoneNumberFb = FormControlTypedOptional<PhoneNumber>(
    validators: [
      ValidatorsTyped.required(),
      ValidatorsTyped.from((control) {
        final value = control.value;
        if (value == null) return null;
        if (value.isValid(type: PhoneNumberType.mobile)) return null;
        return {ValidationCodes.invalid: null};
      }),
    ],
  );

  final _sentCodeFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required(), ValidatorsTyped.text(minLength: 6)],
  );

  @override
  void dispose() {
    _sentCodeFb.dispose();
    _mutation.dispose();
    super.dispose();
  }

  void _signIn() => _mutation(
    (ref) async {
      final phoneNumber = _phoneNumberFb.value!;
      await UsersProviders.signInWithPhoneNumber(ref, phoneNumber.international);
    },
    onError: (error, _) => CoreUtils.showErrorSnackBar(context, error),
    onSettled: (_, result) {
      if (result != null) {
        SignInPhoneNumberRoute(
          organizationId: widget.organizationId,
          verificationId: result,
          shouldPop: widget.shouldPop,
        ).pushReplacement(context);
      }
    },
  );

  void _confirmVerification(String verificationId) => _mutation(
    (ref) async => await UsersProviders.confirmPhoneNumberVerification(
      ref,
      verificationId,
      organizationId: widget.organizationId,
      code: _sentCodeFb.value,
    ),
    onError: (error, _) => CoreUtils.showErrorSnackBar(context, error),
    onSettled: (_, result) {
      if (result != null) {
        final organizationId = widget.organizationId;
        if (widget.shouldPop) {
          Navigator.pop(context, true);
        } else if (organizationId != null) {
          ServicesRoute(organizationId).go(context);
        } else {
          const QrCodeRoute().go(context);
        }
      }
    },
  );

  Widget _buildContent({required Widget title, required Widget field, required Widget action}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(R.svgsTableServiceSticky),
        const Spacer(),
        DefaultTextStyle(
          style: textTheme.headlineSmall!,
          textAlign: TextAlign.center,
          child: title,
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(child: field),
            action,
          ],
        ),
        const Spacer(flex: 4),
      ],
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final verificationId = widget.verificationId;
    switch (verificationId) {
      case null:
        final isIdle = !ref.watch(_mutation.provider.isPending);
        final signIn = _phoneNumberFb.handleSubmit(_signIn);

        return _buildContent(
          title: const Text('Ultimo sforzo, conferma il tuo ordine tramite sms\n\nGrazie!'),
          field: ReactivePhoneFormField(
            formControl: _phoneNumberFb,
            // converter: FieldConvert.text,
            // type: const TextFieldType.numeric(),
            decoration: InputDecorations.borderless.copyWith(
              iconColor: colors.primary,
              icon: const TextIcon('#'),
              hintText: 'numero',
            ),
          ),
          action: OutlinedButton(onPressed: isIdle ? signIn : null, child: const Text('SEND')),
        );
      default:
        final isIdle = !ref.watch(_mutation.provider.isPending);
        final confirmVerification = _sentCodeFb.handleSubmit(
          () => _confirmVerification(verificationId),
        );

        return _buildContent(
          title: const Text('Ultimo sforzo, conferma il tuo ordine tramite sms\n\nGrazie!'),
          field: ReactiveTypedTextField(
            formControl: _sentCodeFb,
            variant: const TextFieldVariant.integer(),
            decoration: InputDecorations.borderless.copyWith(
              iconColor: colors.primary,
              icon: const TextIcon('#'),
              hintText: 'Codice',
            ),
          ),
          action: OutlinedButton(
            onPressed: isIdle ? confirmVerification : null,
            child: const Text('CONFIRM'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PhoneNumber Verification')),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 32.0), child: _buildBody()),
    );
  }
}
