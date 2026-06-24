import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthRepository {
  AuthRepository({
    AuthService? authService,
    FirestoreService? firestore,
  })  : _authService = authService ?? AuthService(),
        _firestore = firestore ?? FirestoreService();

  final AuthService _authService;
  final FirestoreService _firestore;

  Stream<UserProfile?> get authStateChanges => _authService.authStateChanges;

  UserProfile? get currentUser => _authService.currentUser;

  Future<UserProfile> signInWithEmail(String email, String password) =>
      _authService.signInWithEmail(email, password);

  Future<UserProfile> register(String email, String password, String name) async {
    final profile = await _authService.registerWithEmail(email, password, name);
    await _firestore.saveUserProfile(profile);
    return profile;
  }

  Future<void> resetPassword(String email) =>
      _authService.sendPasswordResetEmail(email);

  Future<UserProfile> signInWithGoogle() async {
    final profile = await _authService.signInWithGoogle();
    await _firestore.saveUserProfile(profile);
    return profile;
  }

  Future<UserProfile> signInAsGuest() async {
    try {
      return await _authService.signInAsGuest();
    } catch (_) {
      return _authService.signInAsLocalGuest();
    }
  }

  Future<void> signOut() => _authService.signOut();
}
