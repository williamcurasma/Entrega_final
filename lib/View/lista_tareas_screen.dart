import 'package:flutter/material.dart';
import '../servicios/firestore_service.dart';
import 'agregar_tarea_screen.dart';
import 'editar_tarea_screen.dart';

class ListaTareasScreen extends StatefulWidget {
  const ListaTareasScreen({super.key});

  @override
  State<ListaTareasScreen> createState() => _ListaTareasScreenState();
}

class _ListaTareasScreenState extends State<ListaTareasScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final tareas = await _firestoreService.obtenerTareas();
    setState(() => _tareas = tareas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            onPressed: _cargarTareas,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _tareas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No hay tareas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Presiona el botón + para agregar una nueva tarea',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea['completada'] ?? false,
                      onChanged: (valor) async {
                        await _firestoreService.actualizarTarea(
                          id: tarea['id'],      // ✅ CORREGIDO
                          completada: valor,
                        );
                        _cargarTareas();
                      },
                    ),
                    title: Text(
                      tarea['titulo'] ?? 'Sin título',
                      style: TextStyle(
                        decoration: (tarea['completada'] ?? false)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(tarea['descripcion'] ?? 'Sin descripción'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarTareaScreen(
                                  tarea: tarea,
                                  onActualizado: _cargarTareas,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          onPressed: () {
                            _mostrarDialogoEliminar(tarea['id']);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarTareaScreen(),
            ),
          ).then((_) => _cargarTareas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoEliminar(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: const Text('¿Estás seguro de eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestoreService.eliminarTarea(id);
              _cargarTareas();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tarea eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}