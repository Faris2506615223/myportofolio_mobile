import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_form_scaffold.dart';
import 'package:provider/provider.dart';

/// Form terintegrasi dengan API DRF `/api/v1/projects/` menggunakan autentikasi token.
class ProjectFormPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const ProjectFormPage({super.key, this.onToggleTheme});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  String? _validateUrl(String? value, {required bool requiredField}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return requiredField ? 'Project URL cannot be empty!' : null;
    }
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Please enter a valid HTTP or HTTPS URL.';
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _description = '';
      _techStack = '';
      _projectUrl = '';
      _projectImageUrl = '';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    try {
      final created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          scrollable: true,
          title: const Text('Project successfully created!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${created.title}'),
                Text('Description: ${created.description}'),
                Text('Tech Stack: ${created.techStack}'),
                Text('Project URL: ${created.projectUrl}'),
                if (created.projectImageUrl.isNotEmpty)
                  Text('Project Image URL: ${created.projectImageUrl}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted || confirmed != true) return;
      _resetForm();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please login again.'),
            ),
          );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create project (${e.statusCode}): ${e.message}',
              ),
            ),
          );
      }
    } on http.ClientException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Unable to connect to server. Please try again.'),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PortfolioFormScaffold(
      title: 'Add Project Form',
      destination: DrawerDestination.addProject,
      onToggleTheme: widget.onToggleTheme,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Share a new project to your Django REST Framework portfolio.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-title'),
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Project Title',
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => _title = value,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Title cannot be empty!'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-description'),
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Project Description',
                          alignLabelWithHint: true,
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) => _description = value,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Description cannot be empty!'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-tech-stack'),
                        decoration: const InputDecoration(
                          labelText: 'Tech Stack',
                          hintText: 'e.g., Flutter, Django, PostgreSQL',
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => _techStack = value,
                        validator: (value) {
                          final trimmed = value?.trim() ?? '';
                          if (trimmed.isEmpty) {
                            return 'Tech Stack cannot be empty!';
                          }
                          if (trimmed.length > 150) {
                            return 'Tech Stack must be at most 150 characters.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-url'),
                        decoration: const InputDecoration(
                          labelText: 'Project URL',
                          hintText: 'https://example.com',
                          helperText: 'Required, use HTTP or HTTPS',
                          helperMaxLines: 2,
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        onChanged: (value) => _projectUrl = value,
                        validator: (value) =>
                            _validateUrl(value, requiredField: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-image-url'),
                        decoration: const InputDecoration(
                          labelText: 'Project Image URL (Optional)',
                          hintText: 'https://example.com/image.png',
                          helperText: 'Optional, use HTTP or HTTPS',
                          helperMaxLines: 2,
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        onChanged: (value) => _projectImageUrl = value,
                        validator: (value) =>
                            _validateUrl(value, requiredField: false),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(120, 48),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
