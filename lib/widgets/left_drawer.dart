import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/skill_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      backgroundColor: AppColors.bgMain,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.surface),
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
          ListTile(
            leading: const Icon(Icons.home_outlined),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology_outlined),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('View Skills'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SkillListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Add Skill'),
            onTap: () async {
              final navigator = Navigator.of(context);
              if (!await ensureLoggedIn(context)) return;
              navigator.pushReplacement(
                MaterialPageRoute(builder: (context) => const SkillFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            iconColor: AppColors.accentPurple,
            textColor: AppColors.textPrimary,
            title: const Text('Add Experience'),
            onTap: () async {
              final navigator = Navigator.of(context);
              if (!await ensureLoggedIn(context)) return;
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
            },
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: AppColors.danger,
              textColor: AppColors.textPrimary,
              title: const Text('Logout'),
              onTap: () async {
                final navigator = Navigator.of(context);
                await context.read<AuthState>().logout();
                navigator.pop(); // close the drawer
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              iconColor: AppColors.accentPurple,
              textColor: AppColors.textPrimary,
              title: const Text('Login'),
              onTap: () async {
                await ensureLoggedIn(context);
              },
            ),
        ],
      ),
    );
  }
}
