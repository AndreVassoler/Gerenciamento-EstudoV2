class Subject {
  final String name;

  Subject({required this.name});

  Map<String, dynamic> toJson() => {
        // Método para converter Subject em JSON
        "name": name,
      };

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json["name"], // Retorna um novo Subject com os atributos do JSON
    );
  }
}
