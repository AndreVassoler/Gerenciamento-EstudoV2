import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nome_do_projeto/models/study_model.dart';

class StudyService {
  static const String baseUrl = "http://localhost:3000/studies";

  // Adicionado método addStudy
  Future<void> addStudy(Estudo estudo) async {
    final Map<String, dynamic> studyData = estudo.toJson(); //
    studyData.remove('id');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(studyData),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar o estudo");
    }
  }

  // Adicionado método fetchStudies
  Future<List<Estudo>> fetchStudies() async {
    final response = await http.get(Uri.parse(
        baseUrl)); // Alterado de http.get(baseUrl) para http.get(Uri.parse(baseUrl))
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => Estudo.fromJson(json))
          .toList(); // Alterado de jsonList.map((json) => Estudo.fromJson(json)).toList() para jsonList.map((json) => Estudo.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar estudos");
    }
  }

  // Adicionado método updateStudy
  Future<void> updateStudy(Estudo estudo) async {
    if (estudo.id == null) {
      throw Exception("ID do estudo é nulo, não é possível atualizar");
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${estudo.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(estudo.toJson()),
      );

      print("Update response status: ${response.statusCode}");
      print("Update response body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Erro ao atualizar o estudo: ${response.body}");
      }
    } catch (e) {
      print("Erro no updateStudy: $e");
      throw Exception("Erro ao atualizar o estudo: $e");
    }
  }

  // Adicionado método deleteStudy
  Future<void> deleteStudy(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir o estudo");
    }
  }
}
