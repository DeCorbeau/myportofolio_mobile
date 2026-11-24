import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final String npm = "2506607921";
  final String name = "Faiz";
  final String className = "PBP A";
  final List<ItemHomepage> items = [
    ItemHomepage("View Skills", Icons.psychology, AppColors.actionCyan),
    ItemHomepage("View Experiences", Icons.work, AppColors.actionTeal),      
    ItemHomepage("Add Skill", Icons.add_circle, AppColors.accentPurple),    
    ItemHomepage("Add Experience", Icons.work_outline, AppColors.actionPink),
    ItemHomepage("Logout", Icons.logout, AppColors.danger),  
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic page structure (AppBar, Body, SnackBar).
    return Scaffold(
      // AppBar shows the top bar of the app page.
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text.rich(
          TextSpan(
            text: 'Faiz',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
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
      ),
      drawer: const LeftDrawer(),
      // The body is scrollable and width-limited to avoid overflow.
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Horizontal row showing 3 InfoCards side by side.
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(title: 'NPM', content: npm),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Name', content: name),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Class', content: className),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Middle section: welcome message and the menu button grid.
                  Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: [
                              Text(
                                'PORTFOLIO MENU',
                                style: TextStyle(
                                  color: AppColors.accentPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Welcome to MyPortfolio Mobile!',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // GridView shows the button cards in a 3-column grid.
                        GridView.count(
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          // shrinkWrap sizes the grid to fit its children.
                          shrinkWrap: true,
                          // Scrolling is handled by the outer SingleChildScrollView.
                          physics: const NeverScrollableScrollPhysics(),
                          children: items.map((ItemHomepage item) {
                            return ItemCard(item);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  // Information card that shows a title and its content.
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.accentPurple,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}
