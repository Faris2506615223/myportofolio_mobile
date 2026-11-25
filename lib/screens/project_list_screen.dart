import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key, this.onToggleTheme});

  final VoidCallback? onToggleTheme;

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ApiClient>().getProjects();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getProjects();
    setState(() {
      _projectsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: canGoBack ? const BackButton() : null,
        actions: [
          if (canGoBack)
            Builder(
              builder: (scaffoldContext) => IconButton(
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                tooltip: 'Buka menu navigasi',
                icon: const Icon(Icons.menu),
              ),
            ),
          if (widget.onToggleTheme != null)
            IconButton(
              onPressed: widget.onToggleTheme,
              tooltip: isDark ? 'Aktifkan tema terang' : 'Aktifkan tema gelap',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              ),
            ),
        ],
      ),
      drawer: LeftDrawer(
        destination: DrawerDestination.projects,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load projects: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final projects = snapshot.data ?? const <Project>[];
          if (projects.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: const Center(child: Text('No projects found.')),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (project.techStack.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            project.techStack,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          project.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ProjectDetailScreen(project: project),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
