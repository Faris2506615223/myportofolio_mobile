import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_form_scaffold.dart';

/// Form Tutorial 09: validasi dan pratinjau data tanpa penyimpanan permanen.
class ProjectFormPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const ProjectFormPage({super.key, this.onToggleTheme});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  static const _defaultCategory = 'Web Development';
  static const _categories = [
    _defaultCategory,
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  String _projectName = '';
  String _description = '';
  String _category = _defaultCategory;
  String _technologies = '';
  String _projectLink = '';

  String? _validateLink(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Gunakan URL HTTP atau HTTPS yang valid.';
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    // Form.reset mereset field; variabel yang dibaca dialog juga harus direset.
    setState(() {
      _projectName = '';
      _description = '';
      _category = _defaultCategory;
      _technologies = '';
      _projectLink = '';
    });
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // Judul dan isi ikut bergulir pada layar kecil dengan teks besar.
        scrollable: true,
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Proyek: $_projectName'),
              Text('Deskripsi: $_description'),
              Text('Kategori: $_category'),
              Text('Teknologi: $_technologies'),
              Text('Tautan: $_projectLink'),
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

    // Dismiss lewat Back/barrier mempertahankan draf; OK mereset seluruh isian.
    if (!mounted || confirmed != true) return;
    _resetForm();
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
                        'Ceritakan karya barumu. Periksa isian melalui '
                        'ringkasan sebelum melanjutkan. Data belum '
                        'disimpan permanen.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-name'),
                        decoration: const InputDecoration(
                          labelText: 'Nama Proyek',
                          hintText: 'Nama Proyek',
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => _projectName = value.trim(),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Nama proyek tidak boleh kosong!'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-description'),
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Proyek',
                          hintText: 'Deskripsi Proyek',
                          alignLabelWithHint: true,
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) => _description = value.trim(),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Deskripsi proyek tidak boleh kosong!'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        key: const ValueKey('project-category'),
                        // Nilai awal konstan membuat reset kembali ke default,
                        // bukan ke kategori terakhir yang dipilih pengguna.
                        initialValue: _defaultCategory,
                        isExpanded: true,
                        isDense: false,
                        itemHeight: null,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Proyek',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final category in _categories)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _category = value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-technologies'),
                        decoration: const InputDecoration(
                          labelText: 'Teknologi yang Digunakan',
                          hintText: 'Contoh: Flutter, Django, Figma',
                          helperText: 'Opsional',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => _technologies = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        key: const ValueKey('project-link'),
                        decoration: const InputDecoration(
                          labelText: 'Tautan Proyek',
                          hintText: 'https://example.com',
                          helperText: 'Opsional, gunakan HTTP atau HTTPS',
                          helperMaxLines: 2,
                          errorMaxLines: 3,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        onChanged: (value) => _projectLink = value.trim(),
                        validator: _validateLink,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: _saveProject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(120, 48),
                          ),
                          child: const Text('Save'),
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
