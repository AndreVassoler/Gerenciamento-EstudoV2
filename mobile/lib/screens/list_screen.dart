import 'package:flutter/material.dart';
import 'package:nome_do_projeto/models/study_model.dart';
import 'package:nome_do_projeto/screens/studyFormScreen.dart';
import 'package:nome_do_projeto/services/estudo_service.dart';

class ActivityListScreen extends StatefulWidget {
  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  List<Estudo> _activities = [];
  bool _isLoading = true;
  final StudyService _studyService = StudyService();

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final studies = await _studyService.fetchStudies();
      setState(() {
        _activities = studies
            .map((study) => Estudo(
                  id: study.id ?? 0,
                  titulo: study.titulo,
                  descricao: study.descricao,
                  subject: study.subject,
                ))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erro ao carregar atividades: $e");
    }
  }

  void _editActivity(Estudo activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyFormScreen(study: activity),
      ),
    ).then((_) {
      fetchActivities();
    });
  }

  void _deleteActivity(Estudo activity) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (activity.id != null) {
        await _studyService.deleteStudy(activity.id!);
        fetchActivities();
      } else {
        print("Erro: ID da atividade é nulo");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: ID da atividade é nulo")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao excluir atividade: $e")),
      );
      print("Erro ao excluir atividade: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Atividades'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _activities.isEmpty
              ? Center(child: Text('Nenhuma atividade cadastrada'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    final activity = _activities[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          activity.titulo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Text(
                          activity.descricao,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _editActivity(activity),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteActivity(activity),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
