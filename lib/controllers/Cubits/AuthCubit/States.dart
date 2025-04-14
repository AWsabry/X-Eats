abstract class AuthStates {}

class AuthInitState extends AuthStates {}

class ShowPassState extends AuthStates {}

class ChangeGenderState extends AuthStates {}

class SuccefullLogiInState extends AuthStates {}

class FailgetInformation extends AuthStates {}

class SuccessGetInformation extends AuthStates {}

class SuccessEmailProfile extends AuthStates {}

class CheckEmailExistSuccess extends AuthStates {}

class Cleared extends AuthStates {}

class initialGetEmailState extends AuthStates {}

class initialGetTokenState extends AuthStates {}

class successSignInState extends AuthStates {}

class LoginSuccessfullState extends AuthStates {}

class RegisterSuccessfullState extends AuthStates {}

class LoginPressedState extends AuthStates {}

class getCsrfState extends AuthStates {}

class CheckEmailFailed extends AuthStates {
  final String error;

  CheckEmailFailed(this.error);
}
