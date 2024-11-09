import 'package:flutter/material.dart';
import 'package:nome_do_projeto/models/study_model.dart';
import 'package:nome_do_projeto/models/subject_model.dart';
import 'package:nome_do_projeto/services/estudo_service.dart';

class StudyFormScreen extends StatefulWidget {
  final Estudo? study;

  StudyFormScreen({this.study});

  @override
  _StudyFormScreenState createState() => _StudyFormScreenState();
}

class _StudyFormScreenState extends State<StudyFormScreen> {
  //
  final _formKey = GlobalKey<FormState>(); // Adicionado atributo _formKey
  final _titleController =
      TextEditingController(); // Adicionado atributo _titleController
  final _descriptionController =
      TextEditingController(); // Adicionado atributo _descriptionController
  final _subjectController =
      TextEditingController(); // Adicionado atributo _subjectController
  final StudyService _studyService =
      StudyService(); // Adicionado atributo _studyService

  @override
  void initState() {
    // Adicionado método initState
    super.initState();
    if (widget.study != null) {
      _titleController.text = widget.study!.titulo;
      _descriptionController.text = widget.study!.descricao;
      _subjectController.text = widget.study!.subject.name;
    }
  }

  Future<void> _saveStudy() async {
    // Adicionado método _saveStudy
    if (_formKey.currentState!.validate()) {
      final study = Estudo(
        id: widget.study?.id,
        titulo: _titleController.text,
        descricao: _descriptionController.text,
        subject: Subject(name: _subjectController.text),
      );

      if (widget.study == null) {
        await _studyService.addStudy(study);
      } else {
        await _studyService.updateStudy(study);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.study == null ? 'Novo Estudo' : 'Editar Estudo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  } else if (value.length < 3) {
                    return 'O título deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Matéria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a matéria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  } else if (value.length < 10) {
                    return 'A descrição deve ter pelo menos 10 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveStudy,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(widget.study == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
