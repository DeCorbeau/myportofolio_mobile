import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';

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
                        decoration:
                            buildInputDecoration(hint: 'Team Leadership'),
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
                            .map((entry) => DropdownMenuItem(
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
                                ))
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
                            .map((level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                ))
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
                          hint:
                              'PIC of Ambassador Division — Open House Fasilkom UI 2026',
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
                              side:
                                  const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
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
                                  AppColors.accentPurple),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        side: const BorderSide(
                                            color: AppColors.border),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            summaryRow(
                                                'Skill Name', _skillName),
                                            summaryRow('Category', _category),
                                            summaryRow('Level', _level),
                                            summaryRow('Impact', _impact),
                                            summaryRow('Context',
                                                _experienceContext),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.accentPurple,
                                          ),
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _resetForm();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
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