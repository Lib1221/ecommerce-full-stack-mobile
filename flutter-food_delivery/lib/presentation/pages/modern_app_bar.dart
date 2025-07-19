import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false, // Default to left-aligned
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: leading,
                  )
                else if (Navigator.of(context).canPop())
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: theme.iconTheme.color),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: theme.textTheme.titleLarge?.color,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actions != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.12)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}
