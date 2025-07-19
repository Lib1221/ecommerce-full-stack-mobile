import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? buttonText;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong.',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
                fontSize: 15, color: theme.textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText ?? 'Retry',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
