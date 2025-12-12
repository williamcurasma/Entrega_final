import 'package:flutter/material.dart';
import '../servicios/firestore_service.dart';

class EditarTareaScreen extends StatefulWidget {
  final Map<String, dynamic> tarea;
  final VoidCallback onActualizado;

  const EditarTareaScreen({
    super.key,
    required this.tarea,
    required this.onActualizado,
  });

  @override
  State<EditarTareaScreen> createState() => _EditarTareaScreenState();
}

class _EditarTareaScreenState extends State<EditarTareaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tarea['titulo'] ?? '';
    _descripcionController.text = widget.tarea['descripcion'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _actualizarTarea,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Actualizar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _actualizarTarea() async {
    if (_formKey.currentState!.validate()) {
      await _firestoreService.actualizarTarea(
        id: widget.tarea['id'],  // ✅ CORREGIDO: argumento nombrado
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
      );

      if (context.mounted) {
        Navigator.pop(context);
        widget.onActualizado();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}