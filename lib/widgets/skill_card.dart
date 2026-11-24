import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/skill_list_screen.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  /// The card that is "Logout" while logged in and "Login" while logged out.
  static const String _authItemName = 'Logout';

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final auth = context.read<AuthState>();

    switch (item.name) {
      case 'View Skills':
        navigator.push(
          MaterialPageRoute(builder: (context) => const SkillListScreen()),
        );
      case 'View Experiences':
        navigator.push(
          MaterialPageRoute(builder: (context) => const ExperienceListScreen()),
        );
      case 'Add Skill':
        if (!await ensureLoggedIn(context)) return;
        navigator.push(
          MaterialPageRoute(builder: (context) => const SkillFormPage()),
        );
      case 'Add Experience':
        if (!await ensureLoggedIn(context)) return;
        navigator.push(
          MaterialPageRoute(builder: (context) => const ExperienceFormPage()),
        );
      case _authItemName:
        if (auth.isLoggedIn) {
          await auth.logout();
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('You have been logged out.')),
            );
        } else if (await ensureLoggedIn(context)) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('You are now logged in.')),
            );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild whenever the session changes so the card swaps Login/Logout.
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final showLogin = item.name == _authItemName && !isLoggedIn;
    final label = showLogin ? 'Login' : item.name;
    final icon = showLogin ? Icons.login : item.icon;
    final color = showLogin ? AppColors.actionGreen : item.color;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
