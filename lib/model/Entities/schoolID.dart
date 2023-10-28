class schoolID {
  final String id;

  schoolID({
    this.id,
  });

  factory schoolID.fromJson(Map<String, dynamic> json) {
    return schoolID(id: json['id']);
  }
}
