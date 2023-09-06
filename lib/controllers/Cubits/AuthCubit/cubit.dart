// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/LoginPressed/LoginPressed.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/core/logger.dart';
import 'package:xeats/views/SignIn/SignIn.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());
  static AuthCubit get(context) => BlocProvider.of(context);

  //----------------Authentication--------//

  var XeatOtp1 = TextEditingController();

  //----------------Signin form Variables ------------------------//

  bool isPassword_lpgin = true;
  TextEditingController signin_email = TextEditingController();
  TextEditingController signin_password = TextEditingController();

  //----------------Signup form Variables ------------------------//

  static TextEditingController password = TextEditingController();
  TextEditingController signup_confirm_password = TextEditingController();
  bool isPassword_signup = true;
  bool isPassword_confirm_signup = true;

  //---------------Complete Profile Form Variables---------------//

  TextEditingController datecontroller = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  TextEditingController first_nameController = TextEditingController();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  String? Value;
  String? ValueTitle;
  String? Gender;
  String? title;

  //---------------Complete Profile Methods-------------//

  void changetitle() {
    title = ValueTitle;
  }

  Future<void> CreateUser(
    context, {
    String? first_name,
    String? email,
    String? last_name,
    String? PhoneNumber,
    String? password,
    String? title,
  }) async {
    await Dio().post("${AppConstants.BaseUrl}/create_users_API/", data: {
      "password": password,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "title": title,
      "PhoneNumber": PhoneNumber,
    });
  }

  void LoginPressed() {
    loginPressed = true;
    emit(LoginPressedState());
  }

  int? UserCode;
  Future<int> login(
    context, {
    String? email,
    String? password,
  }) async {
    try {
      await Dio().get("${AppConstants.BaseUrl}/get_csrf_token_api/", data: {
        "email": email,
        "password": password,
      });

      final loginViewToken =
          await Dio().post("${AppConstants.BaseUrl}/login_view/", data: {
        "password": password,
        "email": email,
      });
      UserCode = loginViewToken.data["code"];
      emit(LoginSuccessfullState());
    } catch (error) {
      print("error while Sign In $error");
    }
    return UserCode!;
  }

  //-------------Show password method-------------------//

  void changepasswordVisablityLogin() {
    isPassword_lpgin = !isPassword_lpgin;
    emit(ShowPassState());
  }

  void changepasswordVisablitySignup() {
    isPassword_signup = !isPassword_signup;
    emit(ShowPassState());
  }

  void changepasswordVisablityConfirmSignup() {
    isPassword_confirm_signup = !isPassword_confirm_signup;
    emit(ShowPassState());
  }

  //-----------------Sign In------------//
  //This Function Will Call when user Sign In Succefuly to get the value data and save it in sharedPrefrence
  Future<void> getUserInforamtion({String? email, String? password}) async {
    emit(initialGetEmailState());

    try {
      final tokenResponse =
          await Dio().post("${AppConstants.BaseUrl}/api/token/", data: {
        "email": email,
        "password": password,
      });

      final accessToken = tokenResponse.data['access'];

      final userResponse = await Dio().get(
          "${AppConstants.BaseUrl}/get_user_by_email/${email!.trim()}",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      final userInfo = userResponse.data["Names"][0];

      SharedPreferences userSharedPrefrence =
          await SharedPreferences.getInstance();
      userSharedPrefrence.setString('EmailInf', userInfo['email']);
      userSharedPrefrence.setString('FirstName', userInfo['first_name']);
      userSharedPrefrence.setString('LastName', userInfo['last_name']);
      userSharedPrefrence.setInt("Id", userInfo['id']);
      userSharedPrefrence.setDouble("wallet", userInfo['Wallet']);
      userSharedPrefrence.setString("phonenumber", userInfo['PhoneNumber']);

      emit(SuccessGetInformation());
    } catch (error) {
      print("error message $error");
      emit(FailgetInformation());
      AppLogger.e("error in sign In $error");
    }
  }

//-------------------- Function Separated to get his email if his email null then it will go to login if not then it will go to home page

// Getting USER DATA FROM SHARED PREFREANCE
  String? userEmailShared;
  String? firstNameShared;
  String? lastNameShared;
  int? userIdShared;
  double? walletShared;
  String? phoneNumberShared;

  void GettingUserData() async {
    SharedPreferences User = await SharedPreferences.getInstance();
    userEmailShared = User.getString('EmailInf');
    firstNameShared = User.getString('FirstName');
    lastNameShared = User.getString('LastName');
    userIdShared = User.getInt('Id');
    walletShared = User.getDouble('wallet');
    phoneNumberShared = User.getString('phonenumber');
    emit(SuccessEmailProfile());
  }

  Future<void> signOut(context) async {
    SharedPreferences userInformation = await SharedPreferences.getInstance();
    userInformation.clear();
    NavigateAndRemov(context, SignIn());
    emit(Cleared());
  }
}
