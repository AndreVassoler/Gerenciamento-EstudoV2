import 'package:nome_do_projeto/models/subject_model.dart';

class Estudo {
  final int? id;
  final String titulo;
  final String descricao;
  final Subject subject;

  Estudo(
      // Construtor da classe Estudo
      {this.id,
      required this.titulo,
      required this.descricao,
      required this.subject});

  factory Estudo.fromJson(Map<String, dynamic> json) {
    // Método para converter JSON em Estudo
    return Estudo(
      // Retorna um novo Estudo com os atributos do JSON
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
              json['id'].toString()), // Converte id para int se necessário
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      subject: Subject.fromJson(json['subject']),
    );
  }

  Map<String, dynamic> toJson() {
    // Método para converter Estudo em JSON
    return {
      // Retorna um Map com os atributos do Estudo
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'subject': subject.toJson(),
    };
  }
}
