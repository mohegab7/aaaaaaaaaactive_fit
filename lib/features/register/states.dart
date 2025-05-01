abstract class RegisterStates {}

class Registerintinalstate extends RegisterStates {}

class RegisterloadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  RegisterErrorState(this.error);

  final String error;
}

class CreateUserSuccessState extends RegisterStates {}

class CreateUserErrorState extends RegisterStates {
  CreateUserErrorState(this.error);

  final String error;
}

class RegisterChangePasswordState extends RegisterStates {}
