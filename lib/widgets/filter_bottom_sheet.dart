import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _currentCategory;
  final List<String> _categories = ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Kategori Seminar',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final isSelected = _currentCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _currentCategory = category;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _currentCategory = 'Semua');
                    widget.onApplyFilter('Semua');
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApplyFilter(_currentCategory);
                    Navigator.pop(context);
                  },
                  child: const Text('Terapkan Filter'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
