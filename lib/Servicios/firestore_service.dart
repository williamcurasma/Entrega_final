import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colección de tareas
  CollectionReference get _tareasCollection => 
      _firestore.collection('tareas');

  // ✅ 1. AGREGAR TAREA (CREATE)
  Future<void> agregarTarea({
    required String titulo,
    required String descripcion,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _tareasCollection.add({
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': false,
      'userId': userId,
      'creadoEn': FieldValue.serverTimestamp(),
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  //  2. OBTENER TAREAS (READ)
  Future<List<Map<String, dynamic>>> obtenerTareas() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    try {
      final snapshot = await _tareasCollection
          .where('userId', isEqualTo: userId)
          .orderBy('creadoEn', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("❌ Error obteniendo tareas: $e");
      return [];
    }
  }

  // ✅ 3. ACTUALIZAR TAREA (UPDATE) - MÉTODO COMPLETO
  Future<void> actualizarTarea({
    required String id,
    String? titulo,
    String? descripcion,
    bool? completada,
  }) async {
    final datos = <String, dynamic>{
      'actualizadoEn': FieldValue.serverTimestamp(),
    };
    
    if (titulo != null) datos['titulo'] = titulo;
    if (descripcion != null) datos['descripcion'] = descripcion;
    if (completada != null) datos['completada'] = completada;

    await _tareasCollection.doc(id).update(datos);
  }

  // ✅ 4. ELIMINAR TAREA (DELETE)
  Future<void> eliminarTarea(String id) async {
    await _tareasCollection.doc(id).delete();
  }

  // ✅ 5. OBTENER STREAM EN TIEMPO REAL
  Stream<QuerySnapshot> obtenerTareasStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _tareasCollection
        .where('userId', isEqualTo: userId)
        .orderBy('creadoEn', descending: true)
        .snapshots();
  }

  // ✅ 6. MÉTODO ALTERNATIVO PARA ACTUALIZAR SOLO COMPLETADA
  Future<void> actualizarEstadoTarea({
    required String id,
    required bool completada,
  }) async {
    await _tareasCollection.doc(id).update({
      'completada': completada,
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }
}