import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // Constant default so reset() always restores the same value.
  static const String _defaultCategory = 'Full-Time';

  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _role = "";
  String _organization = "";
  String _description = "";
  String _category = _defaultCategory;
  DateTime? _startDate;
  DateTime? _endDate; // null means the experience is ongoing

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
    'Committee',
  ];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

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

  // Formats a date as dd/mm/yyyy (same as the website date input).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Splits the description into non-empty lines (one bullet point per line).
  List<String> _splitBullets(String text) {
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  // Opens the date picker and stores the chosen date.
  Future<void> _pickDate({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate =
        isStart ? DateTime(2010) : (_startDate ?? DateTime(2010));
    final DateTime lastDate = DateTime(now.year + 5);

    DateTime initial = (isStart ? _startDate : _endDate) ?? now;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  // Clears the end date so the experience counts as ongoing.
  void _clearEndDate() {
    setState(() {
      _endDate = null;
      _endDateController.clear();
    });
  }

  // Reset the form fields and the state variables together.
  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _role = "";
      _organization = "";
      _description = "";
      _category = _defaultCategory;
      _startDate = null;
      _endDate = null;
    });
  }

  // Read-only text field that opens a date picker when tapped.
  Widget _dateField({
    required TextEditingController controller,
    required String hint,
    required Widget suffixIcon,
    required VoidCallback onTap,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: buildInputDecoration(hint: hint, suffixIcon: suffixIcon),
      onTap: onTap,
      validator: validator,
    );
  }

  void _showSummaryDialog() {
    final bullets = _splitBullets(_description);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Experience added successfully!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summaryRow('Position / Role', _role),
                summaryRow('Organization', _organization),
                summaryRow(
                  'Description',
                  bullets.map((b) => '• $b').join('\n'),
                ),
                summaryRow('Category', _category),
                summaryRow('Start Date', _startDateController.text),
                summaryRow(
                  'End Date',
                  _endDate == null ? 'Present' : _endDateController.text,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentPurple,
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
          'Add New Experience',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Hamburger on the right; it still opens the left drawer.
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
                    // === Position / Role ===
                    labeledField(
                      'Position / Role',
                      TextFormField(
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'Person in Charge (PIC) of Ambassador Division',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _role = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Position/role cannot be empty!";
                          }
                          if (value.trim().length > 100) {
                            return "Position/role must be at most 100 characters!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Organization ===
                    labeledField(
                      'Organization',
                      TextFormField(
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'Open House Fasilkom UI 2026',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _organization = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Organization cannot be empty!";
                          }
                          if (value.trim().length > 100) {
                            return "Organization must be at most 100 characters!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Description (one bullet point per line) ===
                    labeledField(
                      'Description (one bullet point per line)',
                      TextFormField(
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'One achievement per line...',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _description = value;
                          });
                        },
                        validator: (String? value) {
                          final bullets = _splitBullets(value ?? '');
                          if (bullets.isEmpty) {
                            return "Description cannot be empty!";
                          }
                          if (bullets.any((line) => line.length > 300)) {
                            return "Each line must be at most 300 characters!";
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
                        initialValue: _defaultCategory,
                        items: _categories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _category = newValue!;
                          });
                        },
                      ),
                    ),
                    // === Start Date ===
                    labeledField(
                      'Start Date',
                      _dateField(
                        controller: _startDateController,
                        hint: 'dd/mm/yyyy',
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onTap: () => _pickDate(isStart: true),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Start date cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === End Date (optional, blank = ongoing) ===
                    labeledField(
                      'End Date (leave blank if ongoing)',
                      _dateField(
                        controller: _endDateController,
                        hint: 'dd/mm/yyyy',
                        suffixIcon: _endDate == null
                            ? const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textSecondary,
                              )
                            : IconButton(
                                icon: const Icon(Icons.close),
                                color: AppColors.textSecondary,
                                tooltip: 'Clear end date',
                                onPressed: _clearEndDate,
                              ),
                        onTap: () => _pickDate(isStart: false),
                        validator: (String? value) {
                          final start = _startDate;
                          final end = _endDate;
                          if (end == null) return null; // ongoing
                          if (start != null && end.isBefore(start)) {
                            return "End date cannot be before the start date!";
                          }
                          return null;
                        },
                      ),
                    ),
                    // === Cancel and Add Experience buttons ===
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
                                _showSummaryDialog();
                              }
                            },
                            child: const Text(
                              'Add Experience',
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