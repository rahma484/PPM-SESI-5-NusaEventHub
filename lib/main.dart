import 'package:flutter/material.dart';
import 'data/sample_events.dart';
import 'models/registration_ticket.dart';
import 'screens/home_events_screen.dart';
import 'screens/registered_tickets_screen.dart';
import 'widgets/venue_map_viewer.dart';

void main() {
  runApp(const NusaEventApp());
}

class NusaEventApp extends StatelessWidget {
  const NusaEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaEvent Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // State tiket yang terdaftar
  final List<RegistrationTicket> _registeredTickets = [
    RegistrationTicket(
      id: 'tkt-init-1',
      ticketCode: 'NEH-2026-AI01',
      eventId: 'evt-1',
      eventTitle: 'Generative AI & LLM Deployment in Enterprise Systems',
      speaker: 'Dr. Arya Wicaksono, M.Kom',
      eventDate: '12 November 2026',
      eventTime: '09:00 - 12:00 WIB',
      eventLocation: 'Auditorium Utama, Nusa Convention Center',
      category: 'AI',
      userName: 'Rahma Aulia',
      userNim: '20240040103',
      userEmail: 'rahma.aulia_ti24@nusaputra.ac.id',
      userWhatsApp: '085723647382',
      participantType: 'Mahasiswa',
      attendanceDate: DateTime(2026, 11, 12),
      kitPackage: 'Standard',
      donationAmount: 25000,
      agreedToTerms: true,
      registeredAt: DateTime(2026, 10, 25),
    ),
  ];

  void _onEventRegistered(RegistrationTicket ticket) {
    setState(() {
      _registeredTickets.insert(0, ticket);
      _currentIndex = 2; // Pindah ke tab tiket terdaftar
    });
  }

  void _onTicketCancelled(String ticketId) {
    setState(() {
      _registeredTickets.removeWhere((t) => t.id == ticketId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.hub_outlined, color: Color(0xFF4F46E5)),
            SizedBox(width: 8),
            Text(
              'NusaEvent Hub',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 1: Seminar & Workshop
          HomeEventsScreen(
            onEventRegistered: (dynamic data){
              if (data is RegistrationTicket){
                _onEventRegistered(data);
              }
            },
          ),
          // Tab 2: Galeri & Denah Venue (GridView & InteractiveViewer)
          _buildGalleryAndVenueTab(),
          // Tab 3: Tiket Terdaftar (Dismissible & AlertDialog)
          RegisteredTicketsScreen(
            tickets: _registeredTickets,
            onTicketCancelled: _onTicketCancelled,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Seminar',
          ),
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Galeri & Denah',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('${_registeredTickets.length}'),
              child: const Icon(Icons.confirmation_number_outlined),
            ),
            selectedIcon: Badge(
              label: Text('${_registeredTickets.length}'),
              child: const Icon(Icons.confirmation_number),
            ),
            label: 'Tiket Saya',
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryAndVenueTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_view), text: 'Galeri Poster'),
              Tab(icon: Icon(Icons.layers_outlined), text: 'Denah Interaktif'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // GridView Poster yang rapi, compact, dan pas tanpa ruang kosong
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 kolom ke samping
                      childAspectRatio: 1.15, // Rasio seimbang agar kompak dan tidak kepanjangan ke bawah
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: sampleEvents.length,
                    itemBuilder: (ctx, i) {
                      final item = sampleEvents[i];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Gambar poster mengisi ruang atas secara fleksibel
                            Expanded(
                              child: Image.network(
                                item.posterUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Judul ringkas di bagian bawah
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Denah Venue menggunakan InteractiveViewer
                const VenueMapViewer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}