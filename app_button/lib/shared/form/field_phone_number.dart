import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mek/mek.dart';
import 'package:phone_form_field/phone_form_field.dart';

class FieldPhoneNumber extends FieldBuilder<PhoneNumber?> {
  final Widget Function(BuildContext context, _FieldPhoneNumberState state) _builder;

  FieldPhoneNumber({
    super.key,
    required super.fieldBloc,
    super.focusNode,

    ////////////////////////////////////////////////////////////////////////////
    bool shouldFormat = true,
    bool enabled = true,
    bool showFlagInInput = true,
    CountrySelectorNavigator countrySelectorNavigator =
        // ignore: deprecated_member_use
        const CountrySelectorNavigator.searchDelegate(),
    void Function(PhoneNumber?)? onSaved,
    IsoCode? defaultCountry,
    // AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    // PhoneNumber? initialValue,
    double flagSize = 16,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.phone,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    // bool readOnly = false,
    bool? showCursor,
    bool obscureText = false,
    String obscuringCharacter = '•',
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    // MaxLengthEnforcement? maxLengthEnforcement,
    // int? maxLines = 1,
    // int? minLines,
    // bool expands = false,
    // int? maxLength,
    // GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    // InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    VoidCallback? onSubmitted,
    // FocusNode? focusNode,
    Iterable<String>? autofillHints,
    MouseCursor? mouseCursor,
    // DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    AppPrivateCommandCallback? onAppPrivateCommand,
    String? restorationId,
    ScrollController? scrollController,
    TextSelectionControls? selectionControls,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    TextStyle? countryCodeStyle,
    bool enableIMEPersonalizedLearning = true,
    bool isCountrySelectionEnabled = true,
    bool isCountryChipPersistent = false,
    ValueChanged<PhoneNumber?>? onChanged,
  }) : _builder = ((context, state) {
          final isEnabled = enabled && state.isEnabled;

          void changeValue(PhoneNumber? value) {
            state.fieldBloc.changeValue(value);
            state.completeEditing();
            onChanged?.call(value);
          }

          final locale = Localizations.localeOf(context);

          return PhoneFormField(
            countryCodeStyle: countryCodeStyle,
            focusNode: state.focusNode,
            // controller: null,
            // ignore: deprecated_member_use
            shouldFormat: shouldFormat,
            onChanged: (value) {
              changeValue(value);
              onChanged?.call(value);
            },
            autofillHints: autofillHints,
            autofocus: autofocus,
            enabled: isEnabled,
            showFlagInInput: showFlagInInput,
            countrySelectorNavigator: countrySelectorNavigator,
            onSaved: onSaved,
            // ignore: deprecated_member_use
            defaultCountry: defaultCountry ??
                IsoCode.values
                    .firstWhere((e) => locale.countryCode == e.name, orElse: () => IsoCode.DE),
            decoration: state.decorate(decoration, isEnabled: isEnabled),
            cursorColor: cursorColor,
            autovalidateMode: AutovalidateMode.disabled,
            flagSize: flagSize,
            onEditingComplete: onEditingComplete,
            restorationId: restorationId,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            showCursor: showCursor,
            obscureText: obscureText,
            autocorrect: autocorrect,
            smartDashesType: smartDashesType ??
                (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
            smartQuotesType: smartQuotesType ??
                (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
            enableSuggestions: enableSuggestions,
            onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
            inputFormatters: inputFormatters,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            scrollPadding: scrollPadding,
            scrollPhysics: scrollPhysics,
            keyboardAppearance: keyboardAppearance,
            enableInteractiveSelection: enableInteractiveSelection,
            mouseCursor: mouseCursor,
            obscuringCharacter: obscuringCharacter,
            onAppPrivateCommand: onAppPrivateCommand,
            scrollController: scrollController,
            selectionControls: selectionControls,
            selectionHeightStyle: selectionHeightStyle,
            selectionWidthStyle: selectionWidthStyle,
            enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
            isCountrySelectionEnabled: isCountrySelectionEnabled,
            // ignore: deprecated_member_use
            isCountryChipPersistent: isCountryChipPersistent,
          );
        });

  @override
  State<FieldBuilder<PhoneNumber?>> createState() => _FieldPhoneNumberState();
}

class _FieldPhoneNumberState extends FieldBuilderState<FieldPhoneNumber, PhoneNumber?> {
  @override
  Widget build(BuildContext context) => widget._builder(context, this);
}
