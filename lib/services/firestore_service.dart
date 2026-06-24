import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _saves =>
      _firestore.collection('game_saves');

  Future<void> saveUserProfile(UserProfile profile) async {
    await _users.doc(profile.id).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  Future<void> saveGameToCloud({
    required String userId,
    required String saveId,
    required Map<String, dynamic> gameData,
    required String saveName,
  }) async {
    await _saves.doc(saveId).set({
      'userId': userId,
      'saveName': saveName,
      'gameData': gameData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> loadGameFromCloud(String saveId) async {
    final doc = await _saves.doc(saveId).get();
    if (!doc.exists) return null;
    return doc.data()?['gameData'] as Map<String, dynamic>?;
  }

  Stream<List<Map<String, dynamic>>> watchCloudSaves(String userId) {
    return _saves
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  }

  Future<void> deleteCloudSave(String saveId) async {
    await _saves.doc(saveId).delete();
  }
}
