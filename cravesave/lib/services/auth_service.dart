import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    required GeoPoint location,
  }) async {
    try {
      // Create auth user
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user model
        UserModel user = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: role.value,
          location: location,
          isVerified: true,
          active: true,
          lastActive: DateTime.now(),
          createdAt: DateTime.now(),
        );

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toMap());

        // Create NGO profile if role is NGO
        if (role == UserRole.ngo) {
          await _createNgoProfile(credential.user!.uid, name);
        }

        return credential;
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
    return null;
  }

  Future<void> _createNgoProfile(String userId, String name) async {
    await _firestore.collection('ngo_profiles').doc(userId).set({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        DocumentSnapshot doc =
            await _firestore
                .collection('users')
                .doc(credential.user!.uid)
                .get();

        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }
      }
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error getting current user: $e');
      rethrow;
    }
  }
}
