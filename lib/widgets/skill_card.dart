import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/skill_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final auth = context.read<AuthState>();

    switch (item.name) {
      case 'View Skills':
        navigator.push(
          MaterialPageRoute(builder: (context) => const SkillListScreen()),
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
      case 'Logout':
        final wasLoggedIn = auth.isLoggedIn;
        await auth.logout();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                wasLoggedIn ? 'You have been logged out.' : 'You are not logged in.',
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
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