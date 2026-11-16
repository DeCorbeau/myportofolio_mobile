import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgMain,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Faiz',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: AppColors.accentPurple),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal skills and experiences!',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Navigate to the portfolio home page
          ListTile(
            leading: const Icon(Icons.home_outlined),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          // Navigate to the add skill page
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Add Skill'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SkillFormPage(),
                ),
              );
            },
          ),
          // Navigate to the add experience page
          ListTile(
            leading: const Icon(Icons.work_outline),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Add Experience'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
            },
          ),          
        ],
      ),
    );
  }
}