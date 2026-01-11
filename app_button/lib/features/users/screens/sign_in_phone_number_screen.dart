import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';

class SignInPhoneNumberScreen extends SourceConsumerStatefulWidget {
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
  SourceConsumerState<SignInPhoneNumberScreen> createState() => _SignInPhoneNumberScreenState();
}

class _SignInPhoneNumberScreenState extends SourceConsumerState<SignInPhoneNumberScreen> {
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

  late final _signIn = ref.mutation(
    (ref, None _) {
      final phoneNumber = _phoneNumberFb.value!;
      return UsersProviders.signInWithPhoneNumber(ref, phoneNumber.international);
    },
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
    onSuccess: (_, verificationId) {
      SignInPhoneNumberRoute(
        organizationId: widget.organizationId,
        verificationId: verificationId,
        shouldPop: widget.shouldPop,
      ).pushReplacement(context);
    },
  );
  late final _confirmVerification = ref.mutation(
    (ref, String verificationId) {
      return UsersProviders.confirmPhoneNumberVerification(
        ref,
        verificationId,
        organizationId: widget.organizationId,
        code: _sentCodeFb.value,
      );
    },
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
    onSuccess: (_, __) {
      final organizationId = widget.organizationId;
      if (widget.shouldPop) {
        context.pop(true);
      } else if (organizationId != null) {
        ServicesRoute(organizationId).go(context);
      } else {
        const QrCodeRoute().go(context);
      }
    },
  );

  @override
  void dispose() {
    _sentCodeFb.dispose();
    super.dispose();
  }

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
        final isIdle = !ref.watchIsMutating([_signIn]);
        final signIn = _phoneNumberFb.handleSubmitWith(_signIn.run);

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
          action: OutlinedButton(
            onPressed: isIdle ? () => signIn(none) : null,
            child: const Text('SEND'),
          ),
        );
      default:
        final isIdle = !ref.watchIsMutating([_confirmVerification]);
        final confirmVerification = _sentCodeFb.handleSubmitWith(_confirmVerification.run);

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
            onPressed: isIdle ? () => confirmVerification(verificationId) : null,
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
