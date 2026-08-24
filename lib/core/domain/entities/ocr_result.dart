class OcrFieldResult {
  const OcrFieldResult({
    required this.fieldType,
    required this.label,
    required this.value,
    this.addressDetail,
  });

  final String fieldType;
  final String label;
  final String value;
  final Map<String, String>? addressDetail;
}

class OcrResult {
  const OcrResult({
    this.fullName,
    this.company,
    this.department,
    this.jobTitle,
    this.fields = const [],
  });

  final String? fullName;
  final String? company;
  final String? department;
  final String? jobTitle;
  final List<OcrFieldResult> fields;
}
