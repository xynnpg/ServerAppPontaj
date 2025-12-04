class Elev {
  final int id;
  final String email;
  final String name;
  final String codMatricol;
  final int activ;
  final DateTime? dataActivare;

  Elev({
    required this.id,
    required this.email,
    required this.name,
    required this.codMatricol,
    required this.activ,
    this.dataActivare,
  });

  factory Elev.fromJson(Map<String, dynamic> json) {
    return Elev(
      id: json['ID'] as int? ?? json['id'] as int? ?? 0,
      email: json['Email'] as String? ?? json['email'] as String? ?? '',
      name: json['Name'] as String? ?? json['nume'] as String? ?? '',
      codMatricol:
          json['CodMatricol'] as String? ??
          json['codmatricol'] as String? ??
          '',
      activ: json['Activ'] as int? ?? json['activ'] as int? ?? 0,
      dataActivare: json['DataActivare'] != null
          ? DateTime.tryParse(json['DataActivare'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Email': email,
      'Name': name,
      'CodMatricol': codMatricol,
      'Activ': activ,
      'DataActivare': dataActivare?.toIso8601String(),
    };
  }
}

class ElevListResponse {
  final String requestedBy;
  final int count;
  final List<Elev> elevi;

  ElevListResponse({
    required this.requestedBy,
    required this.count,
    required this.elevi,
  });

  factory ElevListResponse.fromJson(Map<String, dynamic> json) {
    return ElevListResponse(
      requestedBy: json['requested_by'] as String,
      count: json['count'] as int,
      elevi: (json['elevi'] as List<dynamic>)
          .map((e) => Elev.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
