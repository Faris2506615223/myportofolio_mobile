import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/validators/experience_validators.dart';

void main() {
  test('Posisi dan deskripsi menolak null, kosong, dan whitespace', () {
    for (final value in [null, '', '  \t\n ']) {
      expect(ExperienceValidators.title(value), isNotNull);
      expect(ExperienceValidators.description(value), isNotNull);
    }
  });

  test('Batas posisi mengikuti CharField 255 termasuk Unicode', () {
    expect(ExperienceValidators.title('a' * 255), isNull);
    expect(ExperienceValidators.title('a' * 256), isNotNull);
    expect(ExperienceValidators.title('💡' * 255), isNull);
    expect(ExperienceValidators.title('💡' * 256), isNotNull);
    expect(ExperienceValidators.title('  Asisten PBP  '), isNull);
  });

  test('Input teks biasa menolak markup tanpa menjadi sanitizer HTML', () {
    for (final value in [
      '<b></b>',
      '<p>Peran saya</p>',
      '<script>teks</script>',
    ]) {
      expect(ExperienceValidators.title(value), isNotNull);
      expect(ExperienceValidators.description(value), isNotNull);
    }
    expect(ExperienceValidators.description('Hasil pengujian: 1 < 2.'), isNull);
  });

  test('TextField deskripsi tidak diberi batas panjang buatan', () {
    expect(ExperienceValidators.description('Pengalaman ' * 1000), isNull);
  });

  test('Kategori sama dengan enam choices model Django', () {
    expect(ExperienceCategory.values.map((category) => category.value), [
      'internship',
      'research',
      'volunteer',
      'part-time',
      'full-time',
      'freelance',
    ]);
    expect(ExperienceValidators.category(null), isNotNull);
    for (final category in ExperienceCategory.values) {
      expect(ExperienceValidators.category(category), isNull);
    }
  });

  test('Thumbnail opsional menerima kosong dan URL HTTP/HTTPS', () {
    for (final value in [
      null,
      '',
      '  ',
      'https://example.com/a.jpg',
      ' http://example.com/a.png ',
    ]) {
      expect(ExperienceValidators.thumbnail(value), isNull);
    }
  });

  test('Thumbnail menolak skema, host kosong, dan whitespace yang salah', () {
    for (final value in [
      'javascript:alert(1)',
      'ftp://example.com/a.jpg',
      'data:image/png;base64,abc',
      '/static/a.jpg',
      'gambar.jpg',
      'https://',
      'https://example .com/a.jpg',
    ]) {
      expect(ExperienceValidators.thumbnail(value), isNotNull, reason: value);
    }
  });

  test('Batas thumbnail mengikuti URLField 200 karakter', () {
    const prefix = 'https://example.com/';
    final valid = prefix + 'a' * (200 - prefix.length);
    expect(ExperienceValidators.thumbnail(valid), isNull);
    expect(ExperienceValidators.thumbnail('${valid}a'), isNotNull);
  });
}
