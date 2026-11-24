import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;
  String _thumbnail = "";

  // API values for the dropdown labels.
  static const Map<String, String> _categoryKeys = {
    'Internship': 'internship',
    'Research': 'research',
    'Volunteer': 'volunteer',
    'Part-Time': 'part-time',
    'Full-Time': 'full-time',
    'Freelance': 'freelance',
    'Committee': 'committee',
  };

  // Formats a date as yyyy-MM-dd for the API.
  String _apiDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }  

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
    final DateTime firstDate = isStart
        ? DateTime(2010)
        : (_startDate ?? DateTime(2010));
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
      _thumbnail = "";
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    final token = auth.token;
    if (token == null) return;

    final thumbnail = _thumbnail.trim();
    setState(() {
      _isSubmitting = true;
    });
    try {
      final created = await apiClient.createExperience(
        Experience(
          title: _role.trim(),
          organization: _organization.trim(),
          description: _splitBullets(_description).join('\n'),
          category: _categoryKeys[_category]!,
          thumbnail: thumbnail.isEmpty ? null : thumbnail,
          startedAt: _apiDate(_startDate!),
          endedAt:
              _endDate == null ? null : '${_apiDate(_endDate!)}T00:00:00',
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
          const SnackBar(content: Text('Session expired. Please log in again.')),
        );
        if (!mounted) return;
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Only the portfolio owner can add entries.'),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to save experience (${e.statusCode}).')),
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

  void _showSuccessDialog(Experience created) {
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
                summaryRow('Position / Role', created.title),
                summaryRow('Organization', created.organization),
                summaryRow(
                  'Description',
                  created.descriptionPoints.map((b) => '• $b').join('\n'),
                ),
                summaryRow('Category', created.categoryDisplay),
                summaryRow('Period', created.dateRangeDisplay),
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
              child: const Text('View Experiences'),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExperienceListScreen()),
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
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
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
                    // === Thumbnail URL (optional) ===
                    labeledField(
                      'Thumbnail URL (optional)',
                      TextFormField(
                        keyboardType: TextInputType.url,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: buildInputDecoration(
                          hint: 'https://example.com/image.jpg',
                        ),
                        onChanged: (String value) {
                          _thumbnail = value;
                        },
                        validator: (String? value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return null;
                          final uri = Uri.tryParse(text);
                          if (uri == null ||
                              !(uri.scheme == 'http' || uri.scheme == 'https') ||
                              uri.host.isEmpty) {
                            return "Enter a valid http(s) URL!";
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
                                        strokeWidth: 2),
                                  )
                                : const Text(
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
