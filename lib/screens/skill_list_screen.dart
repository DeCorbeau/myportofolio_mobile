import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/screens/skill_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_style.dart';
import 'package:provider/provider.dart';

/// Display order of the categories, same as the website.
const _categoryOrder = ['leadership', 'event', 'communication', 'technical'];

/// Groups skills by category following [_categoryOrder].
///
/// Skills keep the order returned by the API (by name) inside each group.
/// Unknown categories are collected in a last group so nothing is dropped.
Map<String, List<Skill>> groupSkillsByCategory(List<Skill> skills) {
  final grouped = <String, List<Skill>>{};
  for (final key in _categoryOrder) {
    final items = skills.where((skill) => skill.category == key).toList();
    if (items.isNotEmpty) {
      grouped[key] = items;
    }
  }
  final others = skills
      .where((skill) => !_categoryOrder.contains(skill.category))
      .toList();
  if (others.isNotEmpty) {
    grouped['other'] = others;
  }
  return grouped;
}

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late Future<List<Skill>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    // Created once here, never in build(), so rebuilds do not refetch.
    _skillsFuture = context.read<ApiClient>().getSkills();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getSkills();
    setState(() {
      _skillsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Skills',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Skill>>(
        future: _skillsFuture,
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
                      'Failed to load skills: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
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

          final skills = snapshot.data ?? const <Skill>[];
          if (skills.isEmpty) {
            // Scrollable so pull-to-refresh still works on an empty list.
            return RefreshIndicator(
              onRefresh: _reload,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: const Center(
                      child: Text(
                        'No skills found.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final children = <Widget>[];
          groupSkillsByCategory(skills).forEach((category, items) {
            final color = skillCategoryColor(category);
            children.add(
              _CategorySection(
                label: items.first.categoryDisplay,
                color: color,
                skills: items,
                onDeleted: _reload,
              ),
            );
          });

          return RefreshIndicator(
            onRefresh: _reload,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: children,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatefulWidget {
  const _CategorySection({
    required this.label,
    required this.color,
    required this.skills,
    required this.onDeleted,
  });

  final String label;
  final Color color;
  final List<Skill> skills;
  final VoidCallback onDeleted;

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  color: widget.color,
                  size: 22,
                ),
                Expanded(
                  child: Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.skills.length}',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          for (final skill in widget.skills)
            _SkillCard(
              skill: skill,
              color: widget.color,
              onDeleted: widget.onDeleted,
            ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.skill,
    required this.color,
    required this.onDeleted,
  });

  final Skill skill;
  final Color color;

  /// Called when the detail screen reports that the skill was deleted.
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.card,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () async {
          final deleted = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => SkillDetailScreen(skill: skill),
            ),
          );
          if (deleted == true) {
            onDeleted();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accent line on top of the card, like the website.
            Container(height: 3, color: color),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProficiencyBar(level: skill.proficiency, color: color),
                  const SizedBox(height: 6),
                  Text(
                    skill.proficiencyDisplay,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (skill.impact.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      skill.impact,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  if (skill.context.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      skill.context,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
