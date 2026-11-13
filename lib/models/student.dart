/// Model data profil mahasiswa.
class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Membuat salinan dengan field yang diubah.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  /// Inisial nama untuk CircleAvatar.
  String get initials {
    final list =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (list.isEmpty) return '?';
    if (list.length == 1) return list.first[0].toUpperCase();
    return (list.first[0] + list.last[0]).toUpperCase();
  }
}
