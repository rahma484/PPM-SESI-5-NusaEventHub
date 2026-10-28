import 'package:flutter/material.dart';
import '../models/event_item.dart';

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  final VoidCallback onRegisterTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onRegisterTap,
  });

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category) {
      case 'AI':
        return Colors.deepPurple;
      case 'Mobile':
        return Colors.blue;
      case 'IoT':
        return Colors.teal;
      case 'Cybersecurity':
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getCategoryColor(event.category, context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: categoryColor.withValues(alpha: 0.12),
        highlightColor: categoryColor.withValues(alpha: 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image & Category Badge
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    event.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, _) => Container(
                      color: categoryColor.withValues(alpha: 0.2),
                      child: Icon(Icons.event, size: 48, color: categoryColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person_pin, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.speaker,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(event.date, style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(event.time, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sisa Kuota:',
                            style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                          ),
                          Text(
                            '${event.remainingQuota} dari ${event.quota} kursi',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: event.remainingQuota < 20 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: event.isSoldOut ? null : onRegisterTap,
                        icon: const Icon(Icons.confirmation_number_outlined, size: 16),
                        label: Text(event.isSoldOut ? 'Habis' : 'Daftar Tiket'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}