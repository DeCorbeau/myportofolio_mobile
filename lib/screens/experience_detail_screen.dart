import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/delete_helper.dart';
import 'package:myportofolio_mobile/widgets/experience_style.dart';
import 'package:myportofolio_mobile/widgets/form_helpers.dart';
import 'package:provider/provider.dart';

class ExperienceDetailScreen extends StatefulWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  bool _isDeleting = false;

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete experience?',
      message: 'This will permanently remove it from your portfolio.',
    );
    if (!confirmed || !mounted) return;
    final id = widget.experience.id;
    if (id == null) return;

    final apiClient = context.read<ApiClient>();
    final navigator = Navigator.of(context);
    setState(() {
      _isDeleting = true;
    });
    final deleted = await runDelete(
      context,
      (token) => apiClient.deleteExperience(id, token: token),
      successMessage: 'Experience deleted.',
    );
    if (!mounted) return;
    if (deleted) {
      // Tell the list screen to reload.
      navigator.pop(true);
    } else {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final experience = widget.experience;
    final color = experienceCategoryColor(experience.category);
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Experience Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExperienceThumbnail(url: experience.thumbnailAbsoluteUrl),
                  if (experience.thumbnailAbsoluteUrl.isNotEmpty)
                    const SizedBox(height: 16),
                  Text(
                    experience.categoryDisplay.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  summaryRow('Organization', experience.organization),
                  summaryRow('Period', experience.dateRangeDisplay),
                  summaryRow(
                    'Status',
                    experience.isOngoing ? 'Ongoing' : 'Finished',
                  ),
                  summaryRow(
                    'Description',
                    experience.descriptionPoints.map((p) => '• $p').join('\n'),
                  ),
                  summaryRow('Likes', '${experience.likeCount}'),
                  summaryRow('Liked by', experience.likedByNames),
                  if (isLoggedIn) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isDeleting ? null : _delete,
                        icon: _isDeleting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.delete_outline),
                        label: const Text('Delete Experience'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
