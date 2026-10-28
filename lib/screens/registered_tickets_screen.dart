import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final Function(String ticketId) onTicketCancelled;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onTicketCancelled,
  });

  @override
  State<RegisteredTicketsScreen> createState() => _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
  Future<bool?> _showCancelConfirmationDialog(BuildContext context, RegistrationTicket ticket) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Batalkan Tiket?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan tiket untuk seminar "${ticket.eventTitle}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Tidak, Pertahankan'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Batalkan Tiket'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    if (widget.tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_num_outlined, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Tiket Terdaftar',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih seminar pada tab pertama untuk mendaftar.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.tickets.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, index) {
        final ticket = widget.tickets[index];

        // Dismissible widget untuk fitur pembatalan dengan gesture geser
        return Dismissible(
          key: Key(ticket.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await _showCancelConfirmationDialog(context, ticket);
          },
          onDismissed: (direction) {
            widget.onTicketCancelled(ticket.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tiket ${ticket.ticketCode} berhasil dibatalkan.'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          },
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete_forever, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text(
                  'Geser untuk Batalkan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket.ticketCode,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Aktif',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ticket.eventTitle,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('Speaker: ${ticket.speaker}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama Peserta', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey)),
                          Text(ticket.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('NIM: ${ticket.userNim}', style: theme.textTheme.bodySmall),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Paket Kit', style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey)),
                          Text(ticket.kitPackage, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                          Text(dateFormat.format(ticket.attendanceDate), style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
