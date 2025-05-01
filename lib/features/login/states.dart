abstract class LoginStates {}

class Loginintinalstate extends LoginStates {}

class LoginloadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  // final String uId;

  // LoginSuccessState(this.uId);
}
class LoginGetUserLoadingState extends LoginStates {}
class LoginGetUserSuccessState extends LoginStates {
  // final String uId;

  // LoginGetUserSuccessState(this.uId);
}
class LoginGetUserErrorState extends LoginStates {
  LoginGetUserErrorState(this.error);

  final String error;
}



class LoginWithGoogleSuccessState extends LoginStates {
  // final String uId;

  // LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  LoginErrorState(this.error);

  final String error;
}

class ChangePasswordState extends LoginStates {}

class LoginWithFacebookLoadingState extends LoginStates {}

class LoginWithFacebookSuccessState extends LoginStates {}
