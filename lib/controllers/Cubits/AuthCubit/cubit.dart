// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
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

  TextEditingController password = TextEditingController();
  TextEditingController signup_confirm_password = TextEditingController();
  bool isPassword_signup = true;
  bool isPassword_confirm_signup = true;

  //---------------Complete Profile Form Variables---------------//

  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
    await DioHelper.PostData(data: {
      "password": password,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "title": title,
      "PhoneNumber": PhoneNumber,
    }, url: "create_users_API/");
  }

  List<List> user = [];

  Future<void> login(
    context, {
    String? email,
    String? password,
  }) async {
    await DioHelper.PostData(data: {
      "password": password,
      "email": email,
    }, url: "login_users_API/")
        .then((value) async {
      user = value.data['Names'];
      print(user);
    });
  }

  List<dynamic> EmailExist = [];
  Future<List> CheckExistEmail(context, {String? Email}) async {
    await DioHelper.getdata(url: "get_user_by_id/$Email", query: {})
        .then((value) {
      EmailExist = value.data['Names'];
      print(EmailExist);
      emit(CheckEmailExistSuccess());
    }).catchError((error) {
      print(CheckEmailFailed(error.toString()));
      emit(CheckEmailFailed(error.toString()));
    });
    return EmailExist;
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
  //This Function Will Call when user Sign In Succefuly
  List<dynamic> EmailInList = [];
  Future<List> getEmail(
    context, {
    // The Function Will Get The email of user and take it as EndPoint to show his information
    String? email,
  }) async {
    await DioHelper.getdata(url: "get_user_by_id/$email", query: {})
        .then((value) async {
      //EmailInformationList
      EmailInList = value.data['Names'];
      SharedPreferences userInf = await SharedPreferences.getInstance();
      userInf.setString('EmailInf', EmailInList[0]['email']);
      userInf.setString('FirstName', EmailInList[0]['first_name']);
      userInf.setString('LastName', EmailInList[0]['last_name']);
      userInf.setInt("Id", EmailInList[0]['id']);
      userInf.setDouble("wallet", EmailInList[0]['Wallet']);
      userInf.setString("phonenumber", EmailInList[0]['PhoneNumber']);

      emit(SuccessGetInformation());
    }).catchError((onError) {
      emit(FailgetInformation());
      print(FailgetInformation());
    });
    return EmailInList;
  }

//-------------------- Function Separated to get his email if his email null then it will go to login if not then it will go to home page

  String? EmailInforamtion;
  String? FirstName;
  String? LastName;
  int? idInformation;
  double? wallet;
  String? PhoneNumber;

  Future<void> GettingUserData() async {
    SharedPreferences User = await SharedPreferences.getInstance();
    EmailInforamtion = User.getString('EmailInf');
    FirstName = User.getString('FirstName');
    LastName = User.getString('LastName');
    idInformation = User.getInt('Id');
    wallet = User.getDouble('wallet');
    PhoneNumber = User.getString('phonenumber');
    emit(SuccessEmailProfile());
  }

  Future<void> signOut(context) async {
    SharedPreferences userInformation = await SharedPreferences.getInstance();
    userInformation.clear();
    NavigateAndRemov(context, SignIn());
    emit(Cleared());
  }
}
