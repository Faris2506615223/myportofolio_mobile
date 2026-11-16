import 'package:myportofolio_mobile/models/experience.dart';

/// Aturan input dipisahkan dari widget agar batas model dapat diuji langsung.
abstract final class ExperienceValidators {
  static String? title(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Posisi atau kegiatan tidak boleh kosong!';
    if (text.runes.length > Experience.titleMaxLength) {
      return 'Posisi atau kegiatan maksimal 255 karakter.';
    }
    if (_containsHtml(text)) return 'Gunakan teks biasa tanpa tag HTML.';
    return null;
  }

  static String? description(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Deskripsi pengalaman tidak boleh kosong!';
    if (_containsHtml(text)) return 'Gunakan teks biasa tanpa tag HTML.';
    return null;
  }

  static String? category(ExperienceCategory? value) =>
      value == null ? 'Pilih kategori pengalaman.' : null;

  static String? thumbnail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.runes.length > Experience.thumbnailMaxLength) {
      return 'URL thumbnail maksimal 200 karakter.';
    }
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Gunakan URL thumbnail HTTP atau HTTPS yang valid.';
    }
    return null;
  }

  // Teks ditampilkan apa adanya melalui Text. Ini pemeriksaan format input,
  // bukan sanitizer HTML; server tetap harus menjalankan validasinya sendiri.
  static bool _containsHtml(String value) =>
      RegExp(r'<\s*/?\s*[a-zA-Z][^>]*>').hasMatch(value);
}
