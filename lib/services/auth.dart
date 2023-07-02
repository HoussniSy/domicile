import 'package:firebase_auth/firebase_auth.dart';
import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googlesignIn = GoogleSignIn();


  Future<User?> get user async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> signup(String emailController, passwordController, String pseudo) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);
      if (result.user != null) {
        await DBServices().saveUser(UserM(id: result.user!.uid, emailController: emailController ,pseudo: pseudo, image: ''));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signin(String emailController, String passwordController) async {
    try {
      final result =
      await auth.signInWithEmailAndPassword(email: emailController, password: passwordController);
      if (result.user != null) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetpassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await googlesignIn.signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final user = await auth.signInWithCredential(credential);
      if (user != null) return true;
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async{
    try {
      return auth.signOut();
    } catch (e) {
      return null;
    }
  }

}