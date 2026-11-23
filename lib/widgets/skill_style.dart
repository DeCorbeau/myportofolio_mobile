import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Maps a category key from the API to its portfolio color.
Color skillCategoryColor(String category) {
  switch (category) {
    case 'leadership':
      return AppColors.catLeadership;
    case 'event':
      return AppColors.catEvent;
    case 'communication':
      return AppColors.catCommunication;
    default:
      return AppColors.catTechnical;
  }
}

/// Four-segment proficiency bar, like the website skill cards.
class ProficiencyBar extends StatelessWidget {
  const ProficiencyBar({required this.level, required this.color, super.key});

  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
            decoration: BoxDecoration(
              color: index < level ? color : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
