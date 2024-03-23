import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/eti/features/projects/blocs/projects_bloc.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';

class ProjectScreen extends StatefulWidget {
  final String clientId;

  const ProjectScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _formFb = FieldBloc<String>(
    initialValue: '',
    validator: const RequiredValidation(),
  );

  final _saveMb = MutationBloc();

  void save() {
    _saveMb.handle(() async {
      final project = ProjectDvo(
        id: '',
        name: _formFb.state.value,
      );
      await get<ProjectsBloc>().save(widget.clientId, project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _saveMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub.pop();
      }),
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    final floatingButton = ButtonBuilder(
      formBloc: _formFb,
      mutationBlocs: [_saveMb],
      onPressed: save,
      builder: (context, onPressed) {
        return AppFloatingActionButton(
          onPressed: onPressed,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
          // child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FieldText(
              fieldBloc: _formFb,
              converter: FieldConvert.text,
            ),
          ],
        ),
      ),
      floatingActionButton: floatingButton,
    );
  }
}
