import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';
import 'package:myportofolio_mobile/widgets/skill_style.dart';

class SkillDetailScreen extends StatelessWidget {
  const SkillDetailScreen({required this.skill, super.key});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final color = skillCategoryColor(skill.category);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Skill Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.categoryDisplay.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    skill.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProficiencyBar(level: skill.proficiency, color: color),
                  const SizedBox(height: 16),
                  summaryRow('Proficiency', skill.proficiencyDisplay),
                  summaryRow('Impact', skill.impact),
                  summaryRow('Context', skill.context),
                  summaryRow('Endorsements', '${skill.endorseCount}'),
                  summaryRow('Endorsed by', skill.endorsedByNames),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
