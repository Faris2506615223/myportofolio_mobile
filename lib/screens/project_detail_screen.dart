import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Displays complete details of a single [Project].
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final imageUrl = project.projectImageUrl.trim();

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_outlined),
                              SizedBox(width: 8),
                              Text('Image could not be loaded'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    project.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (project.techStack.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(project.techStack),
                      backgroundColor: colors.primaryContainer,
                      labelStyle: TextStyle(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Project URL',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    project.projectUrl.trim().isEmpty
                        ? 'Not provided'
                        : project.projectUrl,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: project.projectUrl.trim().isEmpty
                          ? colors.onSurfaceVariant
                          : colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
