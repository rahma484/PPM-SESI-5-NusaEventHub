import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  final Function(RegistrationTicket) onSuccess;

  const EventRegistrationScreen({
    super.key,
    required this.event,
    required this.onSuccess,
  });

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  // GlobalKey untuk validasi formulir
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  // State variables
  String _participantType = 'Mahasiswa';
  DateTime? _attendanceDate;
  String _kitPackage = 'Standard';
  double _donationAmount = 25000;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendanceDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _pickAttendanceDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _attendanceDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (pickedDate != null) {
      setState(() {
        _attendanceDate = pickedDate;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui tata tertib untuk melanjutkan pendaftaran.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi network latency
    await Future.delayed(const Duration(seconds: 2));

    final newTicket = RegistrationTicket(
      id: 'tkt-${DateTime.now().millisecondsSinceEpoch}',
      ticketCode: 'NEH-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      eventId: widget.event.id,
      eventTitle: widget.event.title,
      speaker: widget.event.speaker,
      eventDate: widget.event.date,
      eventTime: widget.event.time,
      eventLocation: widget.event.location,
      category: widget.event.category,
      userName: _nameController.text.trim(),
      userNim: _nimController.text.trim(),
      userEmail: _emailController.text.trim(),
      userWhatsApp: _whatsappController.text.trim(),
      participantType: _participantType,
      attendanceDate: _attendanceDate ?? DateTime.now(),
      kitPackage: _kitPackage,
      donationAmount: _donationAmount,
      agreedToTerms: _agreedToTerms,
      registeredAt: DateTime.now(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    widget.onSuccess(newTicket);

    // Menampilkan SnackBar Material 3
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selamat ${newTicket.userName}, tiket Anda berhasil didaftarkan! Kode: ${newTicket.ticketCode}'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pendaftaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Banner summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_number, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Speaker: ${widget.event.speaker}', style: theme.textTheme.bodySmall),
                          Text(widget.event.location, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Identitas Peserta', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Validasi Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama lengkap wajib diisi';
                  if (val.trim().length < 3) return 'Nama minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Validasi NIM
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM / Nomor Identitas *',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'NIM wajib diisi';
                  if (val.trim().length < 6) return 'NIM minimal 6 digit';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Validasi Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Alamat Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                  if (!val.contains('@') || !val.contains('.')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Validasi WhatsApp
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  hintText: 'Contoh: 081234567890',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nomor WhatsApp wajib diisi';
                  if (!val.startsWith('08') && !val.startsWith('62')) {
                    return 'Nomor harus diawali 08 atau 62';
                  }
                  if (val.length < 10) return 'Nomor WhatsApp minimal 10 digit';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pilihan Tipe Peserta
              Text('Tipe Peserta', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Mahasiswa', label: Text('Mahasiswa')),
                  ButtonSegment(value: 'Dosen', label: Text('Dosen')),
                  ButtonSegment(value: 'Umum', label: Text('Umum')),
                ],
                selected: {_participantType},
                onSelectionChanged: (val) => setState(() => _participantType = val.first),
              ),
              const SizedBox(height: 24),

              // Pilihan Tanggal Kehadiran menggunakan showDatePicker()
              Text('Tanggal Kehadiran', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickAttendanceDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.indigo),
                          const SizedBox(width: 12),
                          Text(
                            _attendanceDate == null
                                ? 'Pilih Tanggal'
                                : dateFormat.format(_attendanceDate!),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pilihan Paket Seminar Kit 
              Text('Paket Seminar Kit', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _kitPackage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'Basic',
                    child: Text('Basic (Gratis) - E-Certificate & Handout'),
                  ),
                  DropdownMenuItem(
                    value: 'Standard',
                    child: Text('Standard (+ Rp 25K) - Tote bag, Snack'),
                  ),
                  DropdownMenuItem(
                    value: 'Premium VIP',
                    child: Text('Premium VIP (+ Rp 50K) - Kaos, Tumbler'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _kitPackage = val);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Donasi Pengembangan Event
              Text(
                'Donasi Pengembangan Event: Rp ${_donationAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _donationAmount,
                min: 0,
                max: 100000,
                divisions: 10,
                label: 'Rp ${_donationAmount.toInt()}',
                onChanged: (val) => setState(() => _donationAmount = val),
              ),
              const SizedBox(height: 16),

              // Persetujuan Tata Tertib
              CheckboxListTile(
                value: _agreedToTerms,
                onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                title: const Text('Saya menyetujui seluruh tata tertib dan kebijakan acara NusaEvent Hub.'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Tombol Submit dengan Loading Indicator
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Daftar & Konfirmasi Tiket', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}