class RegistrationTicket {
  final String id;
  final String ticketCode;
  final String eventId;
  final String eventTitle;
  final String speaker;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String category;

  // Data formulir peserta
  final String userName;
  final String userNim;
  final String userEmail;
  final String userWhatsApp;
  final String participantType; // 'Mahasiswa', 'Dosen', 'Umum'
  final DateTime attendanceDate;
  final String kitPackage; // 'Basic', 'Standard', 'Premium VIP'
  final double donationAmount;
  final bool agreedToTerms;
  final DateTime registeredAt;

  const RegistrationTicket({
    required this.id,
    required this.ticketCode,
    required this.eventId,
    required this.eventTitle,
    required this.speaker,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.category,
    required this.userName,
    required this.userNim,
    required this.userEmail,
    required this.userWhatsApp,
    required this.participantType,
    required this.attendanceDate,
    required this.kitPackage,
    required this.donationAmount,
    required this.agreedToTerms,
    required this.registeredAt,
  });
}