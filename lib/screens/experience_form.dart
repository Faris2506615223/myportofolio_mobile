import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/validators/experience_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_form_scaffold.dart';

/// Field mengikuti ExperienceForm Django; tanggal dan metadata tetap read-only.
class ExperienceFormPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const ExperienceFormPage({super.key, this.onToggleTheme});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  ExperienceCategory _category = ExperienceCategory.fullTime;
  bool _hasSubmitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _resetForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    setState(() {
      _category = ExperienceCategory.fullTime;
      _hasSubmitted = false;
    });
  }

  void _fillExample() {
    _resetForm();
    _titleController.text = 'Kontributor Proyek Kuliah';
    _descriptionController.text =
        'Mengembangkan antarmuka aplikasi bersama tim, '
        'menulis pengujian, dan mendokumentasikan hasil pengerjaan.';
    _thumbnailController.text = 'https://example.com/pengalaman.jpg';
  }

  void _saveExperience() {
    setState(() => _hasSubmitted = true);
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    // Dialog membaca snapshot tervalidasi, bukan controller yang dapat berubah.
    final experience = Experience(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      thumbnail: _thumbnailController.text.trim(),
    );
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: const Text('Ringkasan pengalaman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Posisi / Kegiatan: ${experience.title}'),
              const SizedBox(height: 12),
              Text('Deskripsi Pengalaman: ${experience.description}'),
              const SizedBox(height: 12),
              Text('Kategori: ${experience.category.label}'),
              const SizedBox(height: 12),
              Text(
                'URL Thumbnail: '
                '${experience.thumbnail.isEmpty ? 'Tidak diisi' : experience.thumbnail}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PortfolioFormScaffold(
      title: 'Tambah Pengalaman',
      destination: DrawerDestination.addExperience,
      onToggleTheme: widget.onToggleTheme,
      child: Form(
        key: _formKey,
        autovalidateMode: _hasSubmitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setiap pengalaman punya cerita.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Catat peran dan kontribusimu, lalu periksa ringkasannya. '
                      'Data belum disimpan permanen.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _fillExample,
                      icon: const Icon(Icons.auto_awesome_outlined),
                      label: const Text('Isi contoh'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('experience-title'),
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Posisi / Kegiatan',
                        hintText: 'Contoh: Asisten Dosen PBP',
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                      ),
                      maxLength: Experience.titleMaxLength,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      // Django menghitung Unicode code point, bukan jumlah byte.
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            required maxLength,
                          }) => Text(
                            '${_titleController.text.trim().runes.length}/255 karakter',
                            style: theme.textTheme.bodySmall,
                          ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: ExperienceValidators.title,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('experience-description'),
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Pengalaman',
                        hintText: 'Jelaskan peran dan kontribusi utama',
                        alignLabelWithHint: true,
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: ExperienceValidators.description,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<ExperienceCategory>(
                      key: const ValueKey('experience-category'),
                      initialValue: ExperienceCategory.fullTime,
                      isExpanded: true,
                      isDense: false,
                      itemHeight: null,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final category in ExperienceCategory.values)
                          DropdownMenuItem(
                            value: category,
                            child: Text(category.label),
                          ),
                      ],
                      validator: ExperienceValidators.category,
                      onChanged: (value) {
                        if (value != null) setState(() => _category = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('experience-thumbnail'),
                      controller: _thumbnailController,
                      decoration: const InputDecoration(
                        labelText: 'URL Thumbnail',
                        hintText: 'https://example.com/gambar.jpg',
                        helperText:
                            'Opsional. Gunakan HTTP/HTTPS, maksimal 200 karakter.',
                        helperMaxLines: 3,
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      validator: ExperienceValidators.thumbnail,
                      onFieldSubmitted: (_) => _saveExperience(),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _saveExperience,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(120, 48),
                          ),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Simpan'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _resetForm,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(120, 48),
                          ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset'),
                        ),
                      ],
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
