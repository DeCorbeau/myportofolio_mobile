import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';

/// Shared styling and layout helpers used by the portfolio forms.

InputDecoration buildInputDecoration({String? hint, Widget? suffixIcon}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textSecondary),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: border(AppColors.border),
    enabledBorder: border(AppColors.border),
    disabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.accentPurple),
    errorBorder: border(AppColors.danger),
    focusedErrorBorder: border(AppColors.danger),
  );
}

/// Dropdown text style that keeps the theme font (SpaceGrotesk).
TextStyle? dropdownTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge
        ?.copyWith(color: AppColors.textPrimary);

/// Bold label above an input, like the website form.
Widget labeledField(String label, Widget input) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        input,
      ],
    ),
  );
}

/// One "Label: value" line used in the summary dialogs.
Widget summaryRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accentPurple,
            ),
          ),
          TextSpan(
            text: value.isEmpty ? '-' : value,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    ),
  );
}
