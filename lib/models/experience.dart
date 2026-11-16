/// Pilihan dan nilai kategori mengikuti Experience.EXPERIENCE_CHOICES di Django.
enum ExperienceCategory {
  internship('internship', 'Internship'),
  research('research', 'Research'),
  volunteer('volunteer', 'Volunteer'),
  partTime('part-time', 'Part-Time'),
  fullTime('full-time', 'Full-Time'),
  freelance('freelance', 'Freelance');

  final String value;
  final String label;

  const ExperienceCategory(this.value, this.label);
}

/// Snapshot immutable untuk dialog; belum mewakili data yang disimpan di server.
class Experience {
  static const titleMaxLength = 255;
  static const thumbnailMaxLength = 200;

  final String title;
  final String description;
  final ExperienceCategory category;
  final String thumbnail;

  const Experience({
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
  });
}
