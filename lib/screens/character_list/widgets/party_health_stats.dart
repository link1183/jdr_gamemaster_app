import 'package:flutter/material.dart';

class PartyHealthStats extends StatelessWidget {
  final Map<String, dynamic> healthStats;

  const PartyHealthStats({
    super.key,
    required this.healthStats,
  });

  static const Map<String, (String, Color, IconData, String)> categoryInfo = {
    'healthy': ('En forme', Color(0xFF43A047), Icons.favorite, '> 75% HP'),
    'injured': (
      'Blessé',
      Color(0xFFEF6C00),
      Icons.heart_broken,
      '50% - 75% HP'
    ),
    'bloodied': (
      'Mal en point',
      Color(0xFFD32F2F),
      Icons.dangerous,
      '25% - 50% HP'
    ),
    'critical': ('Critique', Color(0xFF6A1B9A), Icons.emergency, '< 25% HP'),
  };

  String _getGroupStatusDescription(int percent) {
    if (percent > 75) return 'Le groupe est en bonne santé';
    if (percent > 50) return 'Le groupe a subi des dégâts modérés';
    if (percent > 25) return 'Le groupe a subi des dégâts importants';
    return 'Le groupe est en danger critique';
  }

  @override
  Widget build(BuildContext context) {
    final categories = healthStats['categories'] as Map<String, int>;
    final theme = Theme.of(context);
    final groupPercent = healthStats['percent'] as int;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: _getGroupStatusDescription(groupPercent),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      groupPercent > 75
                          ? Icons.favorite
                          : groupPercent > 50
                              ? Icons.heart_broken
                              : Icons.warning,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Statut du groupe (${healthStats['percent']}% HP)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text('Catégories de santé'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categoryInfo.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  entry.value.$3,
                                  color: entry.value.$2,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${entry.value.$1}: ${entry.value.$4}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Fermer'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categoryInfo.entries
                .map((entry) {
                  final count = categories[entry.key] ?? 0;
                  if (count == 0) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Tooltip(
                      message:
                          '$count personnage${count > 1 ? 's' : ''} ${entry.value.$1.toLowerCase()}\n${entry.value.$4}',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: entry.value.$2.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: entry.value.$2.withValues(alpha: 0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: entry.value.$2.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              entry.value.$3,
                              color: entry.value.$2,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                color: entry.value.$2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .where((widget) => widget != const SizedBox.shrink())
                .toList(),
          ),
        ],
      ),
    );
  }
}
