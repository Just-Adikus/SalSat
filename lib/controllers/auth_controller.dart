import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salsat_marketplace/controllers/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salsat_marketplace/screens/email_ver_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';


class AuthController extends GetxController {
  var userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;
  Stream<User?> get authState => _auth.authStateChanges();

  String get currentUserId {
    return _auth.currentUser?.uid ?? '';
  }
  Future<void> signUp(String email, String password, String username,
      String phoneNumber) async {
    try {
      CommanDialog.showLoading();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
     userId = userCredential.user!.uid;
      print(userCredential);
      print("userId in signUp: $userId");
      CommanDialog.hideLoading();

      // Отправка подтверждения по электронной почте
      await userCredential.user!.sendEmailVerification();

      try {
        CommanDialog.showLoading();
        var response =
            await FirebaseFirestore.instance.collection('userslist').add({
          'user_Id': userCredential.user!.uid,
          'user_name': username,
          'password': password,
          'joinDate': DateTime.now().millisecondsSinceEpoch,
          'phoneNumber': phoneNumber,
          'email': email,
        });
        print("Firebase response1111 ${response.id}");
        CommanDialog.hideLoading();
        Get.to(() =>
            EmailVerificationScreen()); // Переход на экран подтверждения по электронной почте
      } catch (exception) {
        CommanDialog.hideLoading();
        print("Error Saving Data at firestore $exception");
      }
    } on FirebaseAuthException catch (e) {
      CommanDialog.hideLoading();
      if (e.code == 'weak-password') {
        CommanDialog.showErrorDialog(
            description: ('The_password_provided_is_too_weak'.tr));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CommanDialog.showErrorDialog(
            description: ('The_account_already_exists_for_that_email'.tr));
        print('The account already exists for that email.');
      }
    } catch (e) {
      CommanDialog.hideLoading();
      CommanDialog.showErrorDialog(description: ('Something_went_wrong'.tr));
      print(e);
    }
  }

Future<void> login(email, password) async {
  try {
    // Проверка, был ли вход выполнен через Google
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleSignIn = user?.providerData.any((userInfo) =>
        userInfo.providerId == 'google.com') ?? false;

    if (isGoogleSignIn || _auth.currentUser != null) {
      // Выход из аккаунта Google или Firebase
      await _auth.signOut();

      // Добавление задержки
      await Future.delayed(Duration(seconds: 1));
    }

    CommanDialog.showLoading();
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);
    userId = userCredential.user!.uid;
    print("userId в login: $userId");
    CommanDialog.hideLoading();

    Get.off(() => MainScreen());
  } on FirebaseAuthException catch (e) {
    CommanDialog.hideLoading();
    if (e.code == 'user-not-found') {
      CommanDialog.showErrorDialog(
          description: ('No_user_found_for_that_email'.tr));
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      CommanDialog.showErrorDialog(
          description: ('Wrong_password_provided_for_that_user'.tr));
      print('Wrong password provided for that user.');
    }
  }
}


  Future<void> signInWithPhoneNumber(String phoneNumber, String username,
      String email, void Function(String) onVerificationId) async {
    try {
      CommanDialog.showLoading();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          // userId = userCredential.user!.uid;
          // print("userId in signInWithPhoneNumber: $userId");
          // Проверка существования пользователя в Firestore и добавление его, если он не существует
          final userExists = await FirebaseFirestore.instance
              .collection('userslist')
              .doc(userCredential.user!.uid)
              .get();
          if (!userExists.exists) {
            try {
              await FirebaseFirestore.instance
                  .collection('userslist')
                  .doc(userCredential.user!.uid)
                  .set({
                'user_Id': currentUserId,
                'user_name': username,
                'password': '',
                'joinDate': DateTime.now().millisecondsSinceEpoch,
                'phoneNumber': phoneNumber,
                'email': email,
              });
              print("User added to Firestore");
              CommanDialog.hideLoading();
            } catch (exception) {
              CommanDialog.hideLoading();
              print("Error Saving Data at firestore $exception");
            }
          } else {
            CommanDialog.hideLoading();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          CommanDialog.hideLoading();
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) async {
          CommanDialog.hideLoading();
          onVerificationId(
              verificationId); // Invoke the callback function with the verificationId
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      CommanDialog.hideLoading();
      print('Error occurred while verifying phone number: $e');
    }
  }

Future<User?> signInWithGoogle() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  try {
    GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

    if (googleUser == null) {
      googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Если пользователь нажал 'Отмена'
      }
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    userId = authResult.user!.uid;
    print("userId в signInWithGoogle: $userId");

    final userExists = await FirebaseFirestore.instance
        .collection('userslist')
        .doc(authResult.user!.uid)
        .get();
    if (!userExists.exists) {
      try {
        await FirebaseFirestore.instance
            .collection('userslist')
            .doc(authResult.user!.uid)
            .set({
          'user_Id': currentUserId,
          'user_name': authResult.user!.displayName,
          'password': '',
          'joinDate': DateTime.now().millisecondsSinceEpoch,
          'phoneNumber': '',
          'email': authResult.user!.email,
        });
        print("Пользователь добавлен в Firestore");
      } catch (exception) {
        print("Ошибка при сохранении данных в Firestore: $exception");
      }
    }
    return authResult.user;
  } on FirebaseAuthException catch (e) {
    print('Ошибка входа через Google: ${e.code}, ${e.message}');
    return null;
  }
}


Future<void> signOutGoogle() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  await _googleSignIn.disconnect();
}

}
