import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/widgets/experience_style.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final color = experienceCategoryColor(experience.category);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Experience Detail',
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
                  ExperienceThumbnail(url: experience.thumbnailAbsoluteUrl),
                  if (experience.thumbnailAbsoluteUrl.isNotEmpty)
                    const SizedBox(height: 16),
                  Text(
                    experience.categoryDisplay.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  summaryRow('Organization', experience.organization),
                  summaryRow('Period', experience.dateRangeDisplay),
                  summaryRow(
                    'Status',
                    experience.isOngoing ? 'Ongoing' : 'Finished',
                  ),
                  summaryRow(
                    'Description',
                    experience.descriptionPoints.map((p) => '• $p').join('\n'),
                  ),
                  summaryRow('Likes', '${experience.likeCount}'),
                  summaryRow('Liked by', experience.likedByNames),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}