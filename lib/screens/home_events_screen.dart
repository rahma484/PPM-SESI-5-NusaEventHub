import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'event_registration_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  final Function(EventItem) onEventRegistered;

  const HomeEventsScreen({
    super.key,
    required this.onEventRegistered,
  });

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  String _selectedCategory = 'Semua';
  final List<String> _quickCategories = ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];

  List<EventItem> get _filteredEvents {
    if (_selectedCategory == 'Semua') {
      return sampleEvents;
    }
    return sampleEvents.where((e) => e.category == _selectedCategory).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        onApplyFilter: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  void _navigateToRegistration(EventItem event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => EventRegistrationScreen(
          event: event,
          onSuccess: (ticket) {
            widget.onEventRegistered(event);
          },
        ),
      ),
    );
  }

  void _showEventDetailDialog(EventItem event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(event.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(event.posterUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text('Pembicara: ${event.speaker}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(event.speakerRole, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.place, size: 16, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Expanded(child: Text(event.location, style: const TextStyle(fontSize: 12))),
                ],
              ),
              const SizedBox(height: 8),
              Text(event.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToRegistration(event);
            },
            child: const Text('Daftar Sekarang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Filter chip horizontal bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickCategories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : 'Semua';
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _showFilterModal,
                  icon: const Icon(Icons.tune),
                  tooltip: 'Filter Detail',
                ),
              ],
            ),
          ),
          // List of events using ListView.builder
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada seminar untuk kategori $_selectedCategory',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredEvents.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return EventCard(
                        event: event,
                        onTap: () => _showEventDetailDialog(event),
                        onRegisterTap: () => _navigateToRegistration(event),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}