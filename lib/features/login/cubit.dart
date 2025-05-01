
import 'package:active_fit/features/login/states.dart';
import 'package:active_fit/model/constants/CaheHelper.dart';
import 'package:active_fit/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCuibt extends Cubit<LoginStates> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  LoginCuibt() : super(Loginintinalstate());
  static LoginCuibt get(context) => BlocProvider.of(context);

 UserModel? userModel;
  void getUserdata() {
    emit(LoginGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print(value.data());
      emit(LoginGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LoginGetUserErrorState(error.toString()));
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginloadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);

      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }


void loginwithfacbook(){
  emit(LoginWithFacebookLoadingState());
  FacebookAuth.instance.login(
                  permissions: ["public_profile", "email"]).then((value){
                    FacebookAuth.instance.getUserData().then((userData) {
                      print(userData);
                      print(value.accessToken?.tokenString);
                      final credential = FacebookAuthProvider.credential(value.accessToken!.tokenString);
                      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                        print(value.user?.email);
                        print(value.user?.uid);
                      }).catchError((error) {
                        emit(LoginErrorState(error.toString()));
                      });
                    });
                  });
  emit(LoginWithFacebookSuccessState());
}

Future<User?> signInWithGoogle() async {  
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();  
  
  if (googleUser == null) {  
    // عملية تسجيل الدخول تم إلغاؤها  
    return null;  
  }  

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;  

  if (googleAuth.accessToken == null && googleAuth.idToken == null) {  
    // السلطة لم يتم الحصول عليها بشكل صحيح  
    throw Exception('مشكلة في الحصول على access token أو id token');  
  }  

  final credential = GoogleAuthProvider.credential(  
    accessToken: googleAuth.accessToken,  
    idToken: googleAuth.idToken,  
  );  

  final FirebaseAuth auth = FirebaseAuth.instance;  
  UserCredential userCredential = await auth.signInWithCredential(credential);  
  emit(LoginWithGoogleSuccessState());
  return userCredential.user;  
}


  bool ispassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changepassword() {
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_off : Icons.visibility_outlined;
    emit(ChangePasswordState());
  }

  
}

