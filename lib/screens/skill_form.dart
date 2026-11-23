import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/screens/skill_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class SkillFormPage extends StatefulWidget {
  const SkillFormPage({super.key});

  @override
  State<SkillFormPage> createState() => _SkillFormPageState();
}

class _SkillFormPageState extends State<SkillFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _skillName = "";
  String _category = "Technical"; // default
  String _level = "Beginner"; // default
  String _impact = "";
  String _experienceContext = "";
  bool _isSubmitting = false;

  // API values for the dropdown labels.
  static const Map<String, String> _categoryKeys = {
    'Leadership & Management': 'leadership',
    'Event & Project Coordination': 'event',
    'Communication & Stakeholder Relations': 'communication',
    'Technical': 'technical',
  };

  // Categories with their colors (same as the website).
  final Map<String, Color> _categories = {
    'Leadership & Management': AppColors.catLeadership,
    'Event & Project Coordination': AppColors.catEvent,
    'Communication & Stakeholder Relations': AppColors.catCommunication,
    'Technical': AppColors.catTechnical,
  };

  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  // Go back to the previous page; fall back to Home if there is none.
  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  // Reset the form fields and the state variables together.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _skillName = "";
      _category = "Technical";
      _level = "Beginner";
      _impact = "";
      _experienceContext = "";
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    final token = auth.token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });
    try {
      final created = await apiClient.createSkill(
        Skill(
          name: _skillName.trim(),
          category: _categoryKeys[_category]!,
          proficiency: _levels.indexOf(_level) + 1,
          impact: _impact.trim(),
          context: _experienceContext.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token rejected: clear the session and ask the user to log in again.
        await auth.logout();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
          ),
        );
        if (!mounted) return;
        await ensureLoggedIn(context);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to save skill (${e.statusCode}).')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Cannot reach the server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(Skill created) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Skill added successfully!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summaryRow('Skill Name', created.name),
                summaryRow('Category', created.categoryDisplay),
                summaryRow('Level', created.proficiencyDisplay),
                summaryRow('Impact', created.impact),
                summaryRow('Context', created.context),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add Another'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
            ),
            TextButton(
              child: const Text('View Skills'),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SkillListScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // Back button (overrides the automatic hamburger from the drawer).
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _goBack,
        ),
        title: const Text(
          'Add New Skill',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Hamburger moved to the right; it still opens the left drawer.
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Open navigation menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Skill Name ===
                    labeledField(
                      'Skill Name',
                      TextFormField(
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'Team Leadership',
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _skillName = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Skill name cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Category ===
                    labeledField(
                      'Category',
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        style: dropdownTextStyle(context),
                        decoration: buildInputDecoration(),
                        initialValue: _category,
                        items: _categories.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: entry.value,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        entry.key,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _category = newValue!;
                          });
                        },
                      ),
                    ),
                    // === Proficiency Level ===
                    labeledField(
                      'Proficiency Level',
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        style: dropdownTextStyle(context),
                        decoration: buildInputDecoration(),
                        initialValue: _level,
                        items: _levels
                            .map(
                              (level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _level = newValue!;
                          });
                        },
                      ),
                    ),
                    // === Impact / Achievement ===
                    labeledField(
                      'Impact/Achievement',
                      TextFormField(
                        maxLines: 4,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'Led a team of 8 to hit the division target',
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _impact = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Impact/achievement cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Context ===
                    labeledField(
                      'Context (from which experience)',
                      TextFormField(
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'PIC of Ambassador Division — Open House Fasilkom UI 2026',
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _experienceContext = value!;
                          });
                        },
                      ),
                    ),
                    // === Cancel and Add Skill buttons ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _goBack,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.accentPurple,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Add Skill',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      ),
    );
  }
}
