import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Maps a category key from the API to an accent color.
Color experienceCategoryColor(String category) {
  switch (category) {
    case 'internship':
      return AppColors.accentCyan;
    case 'research':
      return AppColors.catCommunication;
    case 'volunteer':
      return AppColors.catEvent;
    default:
      return AppColors.accentPurple;
  }
}

/// Network thumbnail that silently disappears when the image cannot load.
class ExperienceThumbnail extends StatelessWidget {
  const ExperienceThumbnail({required this.url, this.height = 160, super.key});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
