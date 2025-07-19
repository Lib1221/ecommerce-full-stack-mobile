import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/ui_constants.dart';
import 'utils.dart';

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isUpdating;
  final VoidCallback onRemove;
  final ValueChanged<int> onUpdateQty;
  const CartItemTile(
      {super.key,
      required this.item,
      required this.isUpdating,
      required this.onRemove,
      required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item['product_name'] ?? '';
    final price =
        double.tryParse(item['product_price']?.toString() ?? '0') ?? 0.0;
    final qty = item['quantity'] ?? 1;
    final subtotal = price * qty;
    final image = item['product_image'] ?? '';
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(kCardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: getFullImageUrl(image),
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                          Icons.broken_image,
                          size: 48,
                          color: theme.iconTheme.color?.withOpacity(0.3)),
                    ),
                  )
                : Icon(Icons.image,
                    size: 48, color: theme.iconTheme.color?.withOpacity(0.3)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(' ${price.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                          color: theme.textTheme.bodyMedium?.color)),
                  Text('Subtotal:  ${subtotal.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: isUpdating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(Icons.remove_circle_outline),
                      onPressed: !isUpdating && qty > 1
                          ? () => onUpdateQty(qty - 1)
                          : null,
                    ),
                    Text('$qty',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () => onUpdateQty(qty + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
