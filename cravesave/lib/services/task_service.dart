import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/volunteer_task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create volunteer task
  Future<void> createTask(VolunteerTaskModel task) async {
    await _firestore.collection('volunteer_tasks').doc(task.id).set(task.toMap());
  }

  // Update task status
  Future<void> updateTaskStatus(String taskId, String status, GeoPoint? location) async {
    Map<String, dynamic> updateData = {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (location != null) {
      await _firestore.collection('delivery_logs').add({
        'taskId': taskId,
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    await _firestore.collection('volunteer_tasks').doc(taskId).update(updateData);
  }

  // Get volunteer's tasks
  Stream<QuerySnapshot> getVolunteerTasks(String volunteerId) {
    return _firestore
        .collection('volunteer_tasks')
        .where('volunteerId', isEqualTo: volunteerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get NGO's tasks
  Stream<QuerySnapshot> getNgoTasks(String ngoId) {
    return _firestore
        .collection('volunteer_tasks')
        .where('ngoId', isEqualTo: ngoId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}