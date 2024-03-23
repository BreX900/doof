import 'dart:async';

import 'package:app_button/apis/material/text_icon.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/form/field_phone_number.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:phone_form_field/phone_form_field.dart';

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
  final _phoneNumberFb = FieldBloc<PhoneNumber?>(
    initialValue: null,
    validator: RequiredValidation<PhoneNumber>(validators: [
      (value) {
        if (value.isValid(type: PhoneNumberType.mobile)) return null;
        return const InvalidValidationError();
      }
    ]),
  );

  final _sentCodeFb = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 6),
  );

  late final _signIn = ref.mutation((ref, arg) async {
    final phoneNumber = _phoneNumberFb.state.value!;
    return UsersProviders.signInWithPhoneNumber(ref, phoneNumber.international);
  }, onSuccess: (_, verificationId) {
    SignInPhoneNumberRoute(
      organizationId: widget.organizationId,
      verificationId: verificationId,
      shouldPop: widget.shouldPop,
    ).pushReplacement(context);
  });
  late final _confirmVerification = ref.mutation((ref, String verificationId) async {
    return UsersProviders.confirmPhoneNumberVerification(
      ref,
      verificationId,
      organizationId: widget.organizationId,
      code: _sentCodeFb.state.value,
    );
  }, onSuccess: (_, __) {
    final organizationId = widget.organizationId;
    if (widget.shouldPop) {
      context.pop(true);
    } else if (organizationId != null) {
      ServicesRoute(organizationId).go(context);
    } else {
      const QrCodeRoute().go(context);
    }
  });

  @override
  void dispose() {
    unawaited(_sentCodeFb.close());
    super.dispose();
  }

  Widget _buildContent({
    required Widget title,
    required Widget field,
    required Widget action,
  }) {
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
            Expanded(
              child: field,
            ),
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
        final isIdle = ref.watchIdle(mutations: [_signIn]);
        final canSubmit = ref.watchCanSubmit(_phoneNumberFb);

        return _buildContent(
          title: const Text('Ultimo sforzo, conferma il tuo ordine tramite sms\n\nGrazie!'),
          field: FieldPhoneNumber(
            fieldBloc: _phoneNumberFb,
            // converter: FieldConvert.text,
            // type: const TextFieldType.numeric(),
            decoration: FieldBuilder.decorationBorderless.copyWith(
              iconColor: colors.primary,
              icon: const TextIcon('#'),
              hintText: 'numero',
            ),
          ),
          action: OutlinedButton(
            onPressed: isIdle && canSubmit ? () => _signIn(null) : null,
            child: const Text('SEND'),
          ),
        );
      default:
        final isIdle = ref.watchIdle(mutations: [_confirmVerification]);
        final canSubmit = ref.watchCanSubmit(_sentCodeFb);

        return _buildContent(
          title: const Text('Ultimo sforzo, conferma il tuo ordine tramite sms\n\nGrazie!'),
          field: FieldText(
            fieldBloc: _sentCodeFb,
            converter: FieldConvert.text,
            type: const TextFieldType.integer(),
            decoration: FieldBuilder.decorationBorderless.copyWith(
              iconColor: colors.primary,
              icon: const TextIcon('#'),
              hintText: 'Codice',
            ),
          ),
          action: OutlinedButton(
            onPressed: isIdle && canSubmit ? () => _confirmVerification(verificationId) : null,
            child: const Text('CONFIRM'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhoneNumber Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: _buildBody(),
      ),
    );
  }
}
