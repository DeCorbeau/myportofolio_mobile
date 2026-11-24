import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Asks the user to confirm a destructive action.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

/// Runs an authenticated DELETE request and reports the outcome in a SnackBar.
///
/// [action] receives the token of the current session. Returns true when the
/// item is gone (deleted now, or already missing on the server).
Future<bool> runDelete(
  BuildContext context,
  Future<void> Function(String token) action, {
  required String successMessage,
}) async {
  final auth = context.read<AuthState>();
  final messenger = ScaffoldMessenger.of(context);
  final token = auth.token;
  if (token == null) return false;

  try {
    await action(token);
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    return true;
  } on ApiException catch (e) {
    switch (e.statusCode) {
      case 401:
        // Token rejected: clear the session so the user must log in again.
        await auth.logout();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
          ),
        );
      case 403:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Only the portfolio owner can delete entries.'),
          ),
        );
      case 404:
        messenger.showSnackBar(
          const SnackBar(content: Text('This entry no longer exists.')),
        );
        return true;
      default:
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to delete (${e.statusCode}).')),
        );
    }
    return false;
  } catch (_) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Cannot reach the server.')),
    );
    return false;
  }
}
