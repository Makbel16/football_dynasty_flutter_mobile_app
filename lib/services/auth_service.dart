import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_profile.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  static const _uuid = Uuid();

  Stream<UserProfile?> get authStateChanges =>
      _auth.authStateChanges().map(_mapUser);

  UserProfile? get currentUser => _mapUser(_auth.currentUser);

  UserProfile? _mapUser(User? user) {
    if (user == null) return null;
    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isGuest: user.isAnonymous,
      createdAt: user.metadata.creationTime,
    );
  }

  Future<UserProfile> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user)!;
  }

  Future<UserProfile> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    return _mapUser(credential.user)!;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserProfile> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _mapUser(userCredential.user)!;
  }

  Future<UserProfile> signInAsGuest() async {
    final credential = await _auth.signInAnonymously();
    return _mapUser(credential.user)!;
  }

  Future<UserProfile> signInAsLocalGuest() async {
    return UserProfile(
      id: 'guest_${_uuid.v4()}',
      email: 'guest@footballdynasty.local',
      displayName: 'Guest Manager',
      isGuest: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
