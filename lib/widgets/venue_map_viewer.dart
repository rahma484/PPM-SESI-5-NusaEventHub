import 'package:flutter/material.dart';

class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  final TransformationController _transformationController = TransformationController();

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.pinch, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Geser & Cubit untuk Zoom Denah',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              IconButton.filledTonal(
                onPressed: _resetZoom,
                tooltip: 'Reset Zoom',
                icon: const Icon(Icons.restart_alt, size: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 3.5,
              boundaryMargin: const EdgeInsets.all(40),
              child: Container(
                width: 600,
                height: 480,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey.shade200, width: 2),
                ),
                child: Stack(
                  children: [
                    // Grid background lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _FloorGridPainter(),
                      ),
                    ),
                    // Main Auditorium
                    Positioned(
                      left: 30,
                      top: 30,
                      width: 260,
                      height: 180,
                      child: _buildZoneCard(
                        title: 'Auditorium Utama',
                        subtitle: 'Seminar AI & Keynote',
                        color: Colors.deepPurple,
                        icon: Icons.theater_comedy,
                      ),
                    ),
                    // Workshop Hall A
                    Positioned(
                      left: 310,
                      top: 30,
                      width: 230,
                      height: 90,
                      child: _buildZoneCard(
                        title: 'Workshop Hall A',
                        subtitle: 'Mobile / Flutter',
                        color: Colors.blue,
                        icon: Icons.phone_android,
                      ),
                    ),
                    // Workshop Hall B
                    Positioned(
                      left: 310,
                      top: 130,
                      width: 230,
                      height: 80,
                      child: _buildZoneCard(
                        title: 'Workshop Hall B',
                        subtitle: 'Cybersecurity Lab',
                        color: Colors.redAccent,
                        icon: Icons.security,
                      ),
                    ),
                    // IoT Innovation Lab
                    Positioned(
                      left: 30,
                      top: 230,
                      width: 200,
                      height: 100,
                      child: _buildZoneCard(
                        title: 'Lab Inovasi IoT',
                        subtitle: 'Hardware & Sensors',
                        color: Colors.teal,
                        icon: Icons.memory,
                      ),
                    ),
                    // Registration & Help Desk
                    Positioned(
                      left: 250,
                      top: 230,
                      width: 150,
                      height: 100,
                      child: _buildZoneCard(
                        title: 'Meja Registrasi',
                        subtitle: 'Klaim Seminar Kit',
                        color: Colors.amber.shade800,
                        icon: Icons.badge,
                      ),
                    ),
                    // Sponsor Booths & Lounge
                    Positioned(
                      left: 420,
                      top: 230,
                      width: 120,
                      height: 100,
                      child: _buildZoneCard(
                        title: 'Booth Sponsor',
                        subtitle: 'Networking',
                        color: Colors.indigo,
                        icon: Icons.handshake,
                      ),
                    ),
                    // Entrance / Exit
                    Positioned(
                      left: 210,
                      bottom: 0,
                      width: 180,
                      height: 40,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'PINTU MASUK / KELUAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FloorGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
