import 'package:tatarigigs_user/feature/auth/controller/facebook_login_controller.dart';
import 'package:tatarigigs_user/feature/auth/model/additional_field_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;


  bool _isLoading = false;
  bool _isResendLoading = false;
  bool _isLoggingOut = false;
  bool _acceptTerms = false;
  bool _forgetPasswordUrlSessionExpired = false;
  bool savedCookiesData = false;

  AuthController({required this.authRepo});
  bool get isLoading => _isLoading;
  bool get isResendLoading => _isResendLoading;
  bool get isLoggingOut => _isLoggingOut;
  bool get forgetPasswordUrlSessionExpired => _forgetPasswordUrlSessionExpired;
  bool get acceptTerms => _acceptTerms;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  bool _isNumberLogin = false;
  bool get isNumberLogin => _isNumberLogin;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  bool _isWrongOtpSubmitted = false;
  bool get isWrongOtpSubmitted => _isWrongOtpSubmitted;
  void setWrongOtpSubmitted(bool value) {
    _isWrongOtpSubmitted = value;
  }

  List<AdditionalFieldModel> _additionalFields = [];
  List<AdditionalFieldModel> get additionalFields => _additionalFields;

  Map<String, TextEditingController> _additionalFieldControllers = {};
  Map<String, TextEditingController> get additionalFieldControllers => _additionalFieldControllers;

  Map<String, FocusNode> _additionalFieldFocusNodes = {};
  Map<String, FocusNode> get additionalFieldFocusNodes => _additionalFieldFocusNodes;
  Map<String, List<XFile>> _additionalFieldFiles = {};
  Map<String, List<XFile>> get additionalFieldFiles => _additionalFieldFiles;
  Map<String, dynamic> _additionalFieldCheckValues = {};
  Map<String, dynamic> get additionalFieldCheckValues => _additionalFieldCheckValues;
  Map<String, String> _additionalFieldPhoneCountryCodes = {};
  Map<String, String> get additionalFieldPhoneCountryCodes => _additionalFieldPhoneCountryCodes;

  final Map<String, dynamic> additionalData = {};
  List<MultipartBody> additionalFiles = [];

  LoginMedium  _selectedLoginMedium = LoginMedium.manual;
  LoginMedium  get selectedLoginMedium => _selectedLoginMedium;



  var countryDialCode= "+880";
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;

  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();

  final GoogleSignIn signIn = GoogleSignIn.instance;
  GoogleSignInAccount? googleAccount;




  @override
  void onInit() {
    super.onInit();
    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ? Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;
  }

  Future<void> registration({required SignUpBody signUpBody, String? redirectUrl}) async {

    _isLoading = true;
    update();

    await getAdditionalFieldValues();

      Response response = await authRepo.registration(signUpBody, additionalData: additionalData, additionalFiles: additionalFiles);
      if (response.statusCode == 200 && response.body['response_code'] == 'registration_200') {

        var config = Get.find<SplashController>().configModel.content;
        if(config?.phoneVerification == 1 || config?.emailVerification == 1){

          String identity = config?.phoneVerification == 1 ? signUpBody.phone!.trim() : signUpBody.email!.trim();
          String identityType = config?.phoneVerification == 1 ? "phone" : "email";
          SendOtpType type = config?.phoneVerification == 1 && config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;
          await sendVerificationCode(identity:  identity , identityType: identityType, type: type).then((status){
            if(status !=null){
              if(status.isSuccess!){
                Get.toNamed(RouteHelper.getVerificationRoute(
                  identity: identity,identityType: identityType,
                  fromPage: config?.phoneVerification == 1 && config?.firebaseOtpVerification == 1 ? "firebase-otp" : "verification",
                  firebaseSession: type == SendOtpType.firebase ? status.message : null,
                  redirectUrl: redirectUrl,
                ));
              }else{
                customSnackBar(status.message.toString().capitalizeFirst);
              }
            }
          });

        }else{
          await _saveTokenAndNavigate(
            redirectRoute: redirectUrl ?? (Get.find<LocationController>().getUserAddress() !=null ?  RouteHelper.home : RouteHelper.pickMap),
            token: response.body['content']['token'], emailPhone: "", password: "",
          );
        }
        customSnackBar('registration_200'.tr,type : ToasterMessageType.success);
      }
      else if(response.statusCode == 404 && response.body['response_code']=="referral_code_400"){
        customSnackBar("invalid_refer_code".tr);
      } else if(response.statusCode == 400 && response.body['response_code']=="default_400"){
        customSnackBar(response.body['errors'][0]['message']);
      }
      else {
        ApiChecker.checkApi(response);
      }

    _isLoading = false;
    update();
  }

  Future<void> login({String? redirectRoute, required String emailPhone, required String password, required String type}) async {
      _isLoading = true;
      update();
      Response? response = await authRepo.login(phone: emailPhone, password: password, type: type);
      if (response!.statusCode == 200 && response.body['response_code']=="auth_login_200") {

        await _saveTokenAndNavigate(redirectRoute: redirectRoute, token: response.body['content']['token'], emailPhone: emailPhone, password: password);

      }else if(response.statusCode == 401 && (response.body["response_code"]=="unverified_phone_401") || response.body["response_code"]=="unverified_email_401"){

        var config = Get.find<SplashController>().configModel.content;

        SendOtpType sendOtpType = type == "phone" && config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;
        await sendVerificationCode(identity:  emailPhone , identityType: type,type: sendOtpType).then((status){
          if(status !=null){
            if(status.isSuccess!){
              Get.toNamed(RouteHelper.getVerificationRoute(
                identity: emailPhone,identityType: type,
                fromPage: type == "phone" && config?.firebaseOtpVerification == 1 ? "firebase-otp" : "verification",
                firebaseSession: sendOtpType == SendOtpType.firebase ? status.message : null,
                redirectUrl: redirectRoute,
              ));
            }else{
              customSnackBar(status.message.toString().capitalizeFirst);
            }
          }
        });
      }
      else{
        customSnackBar(response.body["message"].toString().capitalizeFirst??response.statusText, showDefaultSnackBar: false);
      }
      _isLoading = false;
      update();

  }

  Future<void> logOut() async {
    Response? response = await authRepo.logOut();
    if(response?.statusCode == 200){
      if (kDebugMode) {
        print("Logout successfully with ${response?.body}");
      }
    }else{
      if (kDebugMode) {
        print("Logout Failed");
      }
    }
  }

  Future<void> logoutUser() async {
    _isLoggingOut = true;
    update();

    clearSharedData();
    await logOut();
    await googleLogout();
    await signOutWithFacebook();

    _isLoggingOut = false;
    update();
  }

  Future<void> _saveTokenAndNavigate({
    String? redirectRoute,
    required String token,
    String? emailPhone,
    String? password
  }) async {
    await authRepo.saveUserToken(token);

    Get.find<CartController>().clearLocalCartData();
    Get.find<CartController>().refreshCart();

    Get.find<SplashController>().updateLanguage(true);
    Get.find<LocationController>().getAddressList();

    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(number: emailPhone ?? "", password: password ?? "");
    } else {
      clearUserNumberAndPassword();
    }

    if (redirectRoute != null) {
      if (Get.find<LocationController>().getUserAddress() != null) {
        updateSavedLocalAddress();
      }

      final routeData = RouteHelper.parseRedirectRouteToNavigate(redirectRoute);

      Get.offAllNamed(routeData.path, parameters: (routeData.parameters?.isEmpty ?? true) ? null : routeData.parameters);

    } else {
      Get.offAllNamed(RouteHelper.getMainRoute('home'));
    }
  }

  Future<void> updateSavedLocalAddress({bool saveContactPersonInfo = true}) async {

    AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;

    if(saveContactPersonInfo){
      if(Get.find<UserController>().userInfoModel == null){
        Get.find<UserController>().getUserInfo(reload: true);
      }else{
        addressModel.addressLabel = 'others';
      }
    }
    Get.find<LocationController>().saveUserAddress(addressModel);
  }


  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody ,Function callback) async {
    _isLoading = true;
    update();
    Response response = await authRepo.loginWithSocialMedia(socialLogInBody);
    _isLoading = false;
    if (response.statusCode == 200  && response.body['response_code']=="auth_login_200") {
      Map map = response.body;
      String? message = '';
      String? token = '';
      String? tempToken = '';
      String? email;
      UserInfoModel? userInfoModel;
      try{
        message = map['message'] ?? '';
      }catch(e){
        debugPrint('error ===> $e');
      }

      try{
        token = map['content']['token'];
      }catch(e){

        if (kDebugMode) {
          print(e);
        }
      }
      try{
        tempToken = map['content']['temporary_token'];
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }

      try{
        email = map['content']['email'];
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }


      if(map['content']['user'] != null){
        try{
          userInfoModel = UserInfoModel.fromJson(map['content']['user']);
          callback(true, null, message, null, userInfoModel, socialLogInBody.medium, null, null);
        }catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }

      if(token != null){
        saveUserNumberAndPassword(number : "", password : "", );
        await authRepo.saveUserToken(token);
        await authRepo.saveUserToken(token);
        await Get.find<UserController>().getUserInfo(reload: true);
        authRepo.updateToken();
        callback(true, token, message,null, null, null, socialLogInBody.userName, socialLogInBody.email);
      }

      if(tempToken != null){
        callback(true, null, message, tempToken, null, null, socialLogInBody.userName, socialLogInBody.email ?? email);
      }

      update();

    }else {
      String? errorMessage = response.body['message'] ?? response.statusText;
      callback(false, '', errorMessage, null, null, null, socialLogInBody.userName, socialLogInBody.email);
      update();
    }
  }


  Future<ResponseModel?> sendVerificationCode({
    required String identity,
    required String identityType,
    required SendOtpType type,
    int checkUser = 1,
    String fromPage = "",
    bool isResend = false,
    String? redirectUrl,
  }) async {
    ResponseModel? responseModel;
    if(isResend) {
      _isResendLoading = true;
      update();
    }
    if(type == SendOtpType.firebase){

      _sendOtpForFirebaseVerification(
        identity: identity,
        identityType: identityType,
        fromPage: fromPage,
        isResend: isResend,
        redirectUrl: redirectUrl,
      );

    } else if(type == SendOtpType.verification){
      responseModel = await _sendOtpForVerificationScreen(
        identity: identity,
        identityType: identityType,
        checkUser: checkUser,
        isResend: isResend,
      );

    }else{
      responseModel = await _sendOtpForForgetPassword(identity: identity, identityType: identityType, isResend: isResend);
    }
    if(isResend) {
      _isResendLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> _sendOtpForVerificationScreen({required String identity,required String identityType, required int checkUser, bool isResend = false}) async {
    if(!isResend) {
      _isLoading = true;
      update();
    }
    Response  response = await authRepo.sendOtpForVerificationScreen(identity: identity,identityType: identityType, checkUser: checkUser);
    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      if(!isResend) {
        _isLoading = false;
        update();
      }
      return ResponseModel(true, "");
    } else {
      if(!isResend) {
        _isLoading = false;
        update();
      }
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }

  Future<ResponseModel> _sendOtpForForgetPassword({required String identity, required String identityType, bool isResend = false}) async {
    if(!isResend) {
      _isLoading = true;
      update();
    }
    Response response = await authRepo.sendOtpForForgetPassword(identity,identityType);

    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      if(!isResend) {
        _isLoading = false;
        update();
      }
      return ResponseModel(true, "");
    } else {
      if(!isResend) {
        _isLoading = false;
        update();
      }
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }

  Future<void> _sendOtpForFirebaseVerification({required String identity, required String identityType, required String fromPage, bool isResend = false, String? redirectUrl}) async {
    if(!isResend) {
      _isLoading = true;
      update();
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: identity,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if(!isResend) {
          _isLoading = false;
        }
        if(isResend) {
          _isResendLoading = false;
        }
        update();
        if(fromPage == "profile"){
          Get.back();
        }
        if(e.code == 'invalid-phone-number') {
          customSnackBar('please_submit_a_valid_phone_number', type: ToasterMessageType.info);

        }else{
          customSnackBar('${e.message}'.replaceAll('_', ' ').capitalizeFirst);
        }

      },
      codeSent: (String vId, int? resendToken) {
        if(!isResend) {
          _isLoading = false;
        }
        if(isResend) {
          _isResendLoading = false;
        }
        update();
        if(fromPage == "profile"){
          Get.back();
        }
        Get.toNamed(RouteHelper.getVerificationRoute(
          identity:identity,
          identityType : identityType,
          fromPage: fromPage == "forget-password" ? "forget-password" : "firebase-otp",
          firebaseSession: vId,
          redirectUrl: redirectUrl,
        ));

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }


  Future<void>  verifyOtpForVerificationScreen({
    required String identity,
    required String identityType,
    required String otp,
    required String fromPage,
    String? redirectUrl,
  }) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForVerificationScreen(identity,identityType,otp);

    if (response!.statusCode == 200 && response.body['response_code']=="default_200") {
      customSnackBar(response.body["message"],type : ToasterMessageType.success);
      if(fromPage == "profile"){
        Get.find<UserController>().getUserInfo(reload: false);
        if(Navigator.canPop(Get.context!)){
          Navigator.pop(Get.context!);
        }else{
          Get.toNamed(RouteHelper.getEditProfileRoute());
        }
      }else{
        await _saveTokenAndNavigate(
          redirectRoute: redirectUrl ?? (Get.find<LocationController>().getUserAddress() !=null ?  RouteHelper.home : RouteHelper.pickMap),
          token: response.body['content']['token'], emailPhone: "", password: "",
        );
      }
    } else {
      ResponseModel responseModel = _checkWrongOtp(response);
      customSnackBar(responseModel.message.toString().capitalizeFirst);
    }
    _isLoading = false;
    update();

  }


  Future<ResponseModel> verifyOtpForForgetPasswordScreen(String identity, String identityType, String otp, {bool fromOutsideUrl = false , bool shouldUpdate = true}) async {

    _isLoading = true;

    if(fromOutsideUrl){
      _forgetPasswordUrlSessionExpired = true;
    }

    if(shouldUpdate){
      update();
    }

    Response response = await authRepo.verifyOtpForForgetPassword(identity, identityType, otp);

    if (response.statusCode==200 &&  response.body['response_code'] == 'default_200') {
      _isLoading = false;
      _forgetPasswordUrlSessionExpired = false;
      update();
      return ResponseModel(true, "successfully_verified");
    }else{
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else if(response.statusCode == 400 && response.body['errors'] !=null ){
        responseText = response.body['errors'][0]['message'];
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }

  }


  Future<void>  verifyOtpForPhoneOtpLogin({required String phone, required String otp, String? redirectUrl}) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForPhoneOtpLogin(phone: phone, otp: otp);

    if (response!.statusCode == 200) {

      if(response.body['content']['token'] !=null){
       await _saveTokenAndNavigate(
         redirectRoute : redirectUrl ?? RouteHelper.getMainRoute("home"),
         token: response.body['content']['token'],
         emailPhone: phone, password: "",
       );
      } else if(response.body['content']['temporary_token'] !=null){
        Get.offNamed(RouteHelper.getUpdateProfileRoute(phone: phone, redirectUrl: redirectUrl));
      }

    } else {
      ResponseModel responseModel = _checkWrongOtp(response);
      customSnackBar(responseModel.message ?? "");
    }
    _isLoading = false;
    update();
  }


  Future<void>  verifyOtpForFirebaseOtp({String? session, String? phone, String? code , required String fromPage, String? redirectUrl}) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForFirebaseOtpLogin(session: session, phone: phone, code: code);

    if (response!.statusCode == 200) {
      if(fromPage == "forget-password"){
        Get.offNamed(RouteHelper.getChangePasswordRoute(body: ForgetPasswordBody(
          identity: phone,
          identityType: "phone",
          otp: code,
          fromUrl: 0,
          isFirebaseOtp: 1
        ), redirectUrl: redirectUrl));
      }else{
        if(response.body['content']['token'] !=null){
          await _saveTokenAndNavigate(redirectRoute: redirectUrl ?? (Get.find<LocationController>().getUserAddress() !=null ?  RouteHelper.home : RouteHelper.pickMap), token: response.body['content']['token'], emailPhone: phone);
        } else if(response.body['content']['temporary_token'] !=null){
          Get.offNamed(RouteHelper.getUpdateProfileRoute(phone: phone ??"", redirectUrl: redirectUrl));
        }
      }

    } else {
      ResponseModel responseModel = _checkWrongOtp(response);
      customSnackBar(responseModel.message);
    }
    _isLoading = false;
    update();
  }


  Future<void>  updateNewUserProfileAndLogin({String? firstName, String? lastName, String? phone, String? email, String? redirectUrl}) async {
    _isLoading = true;
    update();

    await getAdditionalFieldValues();

    Response response = await authRepo.updateNewUserProfileAndLogin(firstName: firstName, lastName: lastName, phone: phone, email: email, additionalData: additionalData, additionalFiles: additionalFiles);

    if (response.statusCode == 200) {
      if(response.body['content']['token'] !=null){
        await _saveTokenAndNavigate(
          redirectRoute: redirectUrl
              ?? ( Get.find<LocationController>().getUserAddress() !=null
                  ?  RouteHelper.home : RouteHelper.pickMap),
          token: response.body['content']['token'], emailPhone: phone, password: "",
        );
      }

    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia({String? firstName, String? lastName, String? phone, String? email, String? redirectUrl}) async{
    _isLoading = true;
    update();

    await getAdditionalFieldValues();

    Response response = await authRepo.registerWithSocialMedia(firstName: firstName, lastName: lastName, phone: phone, email: email, additionalFiles: additionalFiles, additionalData: additionalData);

    if (response.statusCode == 200) {
      if(response.body['content']['token'] !=null){
        await _saveTokenAndNavigate(
          redirectRoute: redirectUrl ?? (Get.find<LocationController>().getUserAddress() !=null ?  RouteHelper.home : RouteHelper.pickMap),
          token: response.body['content']['token'], emailPhone: "", password: "",
        );
      }
      else if(response.body['content']['temporary_token'] != null){
        var config = Get.find<SplashController>().configModel.content;
        SendOtpType  type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;

        await sendVerificationCode(identity: phone!, identityType: "phone", type: type).then((status){
          if(status !=null){
            if(status.isSuccess!){
              Get.toNamed(RouteHelper.getVerificationRoute(
                identity: phone,identityType: "phone",
                fromPage: type == SendOtpType.firebase ? "firebase-otp" : "otp-login",
                firebaseSession: type == SendOtpType.firebase ? status.message : null,
                redirectUrl: redirectUrl,
              ));
            }else{
              customSnackBar(status.message.toString().capitalizeFirst);
            }
          }
        });
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  Future<void> existingAccountCheck({String? email, required int userResponse, required String medium, String? redirectUrl}) async{
    _isLoading = true;
    update();
    Response response = await authRepo.existingAccountCheck(email: email ?? "", userResponse: userResponse, medium: medium);
    if (response.statusCode == 200) {

      if(response.body['content']['token'] !=null){
       await _saveTokenAndNavigate(redirectRoute: redirectUrl ?? (Get.find<LocationController>().getUserAddress() !=null ?  RouteHelper.home : RouteHelper.pickMap), token: response.body['content']['token']);
      }else if(response.body['content']['temporary_token'] !=null){

        Get.offNamed(RouteHelper.getUpdateProfileRoute(
          email: email ??"",
          tempToken: response.body['content']['temporary_token'],
          redirectUrl: redirectUrl,
        ));
      }

    } else {
     ApiChecker.checkApi(response);
    }
    _isLoading= false;
    update();
  }





  Future<void> resetPassword({
    required String identity,
    required String identityType,
    required String otp,
    required String password,
    required String confirmPassword,
    required int isFirebaseOtp,
    String? redirectUrl,
  }) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.resetPassword(identity,identityType, otp, password, confirmPassword, isFirebaseOtp);

    if (response!.statusCode == 200 && response.body['response_code']=="default_password_reset_200") {
      Get.offNamed(RouteHelper.getSignInRoute(redirectUrl: redirectUrl));
      customSnackBar('password_changed_successfully'.tr,type : ToasterMessageType.success);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  ResponseModel _checkWrongOtp (Response response){
    if (verificationCode.length == 6 && response.statusCode == 403){
      _isWrongOtpSubmitted = true;
    }
    String responseText = "";
    if(response.statusCode == 500){
      responseText = "Internal Server Error";
    }else{
      responseText = response.body["message"] ?? "verification_failed".tr ;
    }
    return ResponseModel(false, responseText);
  }


  void updateVerificationCode(String query) {
    _verificationCode = query;
    _isWrongOtpSubmitted = false;
    update();
  }

  void updateForgetPasswordUrlSessionExpiredStatus({required bool status, bool shouldUpdate = false}){
    _forgetPasswordUrlSessionExpired = status;
    if(shouldUpdate){
      update();
    }
  }


  void toggleTerms({bool? value , bool shouldUpdate = true}) {
    if(value != null){
      _acceptTerms = value;
    }else{
      _acceptTerms = !_acceptTerms;
    }
    if(shouldUpdate){
      update();
    }
  }

  void toggleIsNumberLogin ({bool? value, bool isUpdate = true}){
    if(value == null){
      _isNumberLogin = !_isNumberLogin;
    }else{
      _isNumberLogin = value;
    }
    initCountryCode();
    if(isUpdate){
      update();
    }
  }

  void toggleSelectedLoginMedium ({required LoginMedium loginMedium, bool isUpdate = true}){
    _selectedLoginMedium = loginMedium;
    if(isUpdate){
      update();
    }
  }


  void cancelTermsAndCondition(){
    _acceptTerms = false;
  }

  void toggleRememberMe({bool? value, bool shouldUpdate = true}) {

    if(value != null){
      _isActiveRememberMe = value;
    }else{
      _isActiveRememberMe = !_isActiveRememberMe;
    }
    if(shouldUpdate){
      update();
    }
  }

  void toggleReferralBottomSheetShow (){
    authRepo.toggleReferralBottomSheetShow(false);
    update();
  }

  bool getIsShowReferralBottomSheet (){
    return authRepo.getIsShowReferralBottomSheet();
  }


  bool isLoggedIn() => authRepo.isLoggedIn();
  String getUserNumber() => authRepo.getUserNumber();
  String getUserCountryCode() => authRepo.getUserCountryCode();
  String getUserPassword() => authRepo.getUserPassword();
  bool isNotificationActive() => authRepo.isNotificationActive();

  void saveUserNumberAndPassword({ required String number, required String password}) =>
      authRepo.saveUserNumberAndPassword(number, password, countryDialCode);
  Future<bool> clearUserNumberAndPassword() async => authRepo.clearUserNumberAndPassword();

  bool clearSharedData({Response? response}) {
    final bool cleared = authRepo.clearSharedData(response: response);

    Get.find<CartController>().clearLocalCartData();
    if (response == null) {
      Get.find<CartController>().refreshCart();
    }

    return cleared;
  }

  String getUserToken() => authRepo.getUserToken();


  void toggleNotificationSound(){
    authRepo.toggleNotificationSound(!isNotificationActive());
    update();
  }



  // GoogleSignInAccount? googleAccount;
  // GoogleSignInAuthentication? auth;

  // Future<void> socialLogin() async {
  //   googleAccount = (await _googleSignIn.signIn());
  //   auth = await googleAccount?.authentication;
  //   update();
  // }



  // Future<void> googleLogout() async {
  //   try{
  //     googleAccount = (await _googleSignIn.disconnect())!;
  //     auth = await googleAccount!.authentication;
  //   }catch(e){
  //     if (kDebugMode) {
  //       print("");
  //     }
  //   }
  // }


  Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<void> saveUserToken({required String token}) async {
    await authRepo.saveUserToken(token);
    update();
  }

  void initCountryCode({String? countryCode}){
    countryDialCode = countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode ?? "+880";
  }

  Future<SocialLogInBody?> googleLogin() async {
    SocialLogInBody? socialLoginModel;

    try {
      if(signIn.supportsAuthenticate()) {
        await signIn.initialize(serverClientId: AppConstants.googleServerClientId)
            .then((_) async {

          googleAccount = await signIn.authenticate();
          const List<String> scopes = <String>['email'];
          final auth = await googleAccount?.authorizationClient.authorizationForScopes(scopes);

          socialLoginModel = SocialLogInBody(
            uniqueId: auth?.accessToken,
            token: auth?.accessToken,
            medium: SocialLoginType.google.name,
            email: googleAccount?.email,
            userName: googleAccount?.displayName,
            guestId: Get.find<SplashController>().getGuestId(),
          );
        });
      }else {
        debugPrint("Google Sign-In not supported on this device.");
      }
    } catch (e) {
      debugPrint("google_login: $e");
    }

    return socialLoginModel;
  }


  Future<SocialLogInBody?> facebookLogin() async {
    final FacebookLoginController facebookLoginController = Get.find<FacebookLoginController>();

    await facebookLoginController.login();

    if (facebookLoginController.result.status == LoginStatus.success) {
      final Map userData = await facebookLoginController.facebookAuth.getUserData(fields: 'name, email');

      return SocialLogInBody(
        email: userData['email'],
        token: facebookLoginController.result.accessToken?.tokenString,
        uniqueId: userData['id'],
        medium: SocialLoginType.facebook.name,
        userName: userData['name'],
        guestId: Get.find<SplashController>().getGuestId(),
      );
    }

    return null;
  }

  Future<void> googleLogout() async {
    try{
      await signIn.signOut();
      await signIn.disconnect();
    }catch(e){
      debugPrint("Error: $e");
    }
  }

  Future<void> facebookLogout() async {
    await Get.find<FacebookLoginController>().facebookAuth.logOut();

  }

  void loadAdditionalFields(bool fromSignup) {
    _additionalFields = [];
    if(fromSignup){
      _additionalFields = Get.find<SplashController>().configModel.content?.additionalFieldList ?? [];
    }else{
      (Get.find<SplashController>().configModel.content?.additionalFieldList ?? []).forEach((field){
        if(field.isRequired){
          _additionalFields.add(field);
        }
      });
    }
    _initAdditionalFieldControllers();
  }

  void _initAdditionalFieldControllers() {
    for (var controller in _additionalFieldControllers.values) {
      controller.dispose();
    }
    for (var node in _additionalFieldFocusNodes.values) {
      node.dispose();
    }
    _additionalFieldControllers.clear();
    _additionalFieldFocusNodes.clear();
    _additionalFieldFiles.clear();
    _additionalFieldCheckValues.clear();
    _additionalFieldPhoneCountryCodes.clear();

    for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox) {
        if (field.options?.isNotEmpty == true) {
          _additionalFieldCheckValues[field.id] = <String>[];
        } else {
          _additionalFieldCheckValues[field.id] = false;
        }
      } else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        _additionalFieldCheckValues[field.id] = '';
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id] = [];
      } else {
        _additionalFieldControllers[field.id] = TextEditingController();
        _additionalFieldFocusNodes[field.id] = FocusNode();
        if (field.fieldType == AdditionalFieldType.phone) {
          _additionalFieldPhoneCountryCodes[field.id] = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode ?? '+880';
        }
      }
    }
  }

  void setAdditionalFieldFile(String fieldId, List<XFile> files) {
    _additionalFieldFiles[fieldId] = files;
    update();
  }

  void setAdditionalFieldCheckValue(String fieldId, dynamic value) {
    _additionalFieldCheckValues[fieldId] = value;
    update();
  }

  void setAdditionalFieldPhoneCountryCode(String fieldId, String countryCode) {
    _additionalFieldPhoneCountryCodes[fieldId] = countryCode;
    update();
  }


  Future<Map<String, dynamic>> getAdditionalFieldValues() async{
    additionalFiles = [];
    for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox || field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        additionalData[field.title] = _additionalFieldCheckValues[field.id] ?? (field.options?.isNotEmpty == true ? [] : false);
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id]?.forEach((file){
          additionalFiles.add(MultipartBody('additional_data[${field.title}][]', file));
        });
      } else {
        String value = _additionalFieldControllers[field.id]?.text.trim() ?? '';
        if (field.fieldType == AdditionalFieldType.phone && value.isNotEmpty) {
          value = (_additionalFieldPhoneCountryCodes[field.id] ?? '') + value;
        }
        additionalData[field.title] = value;
      }
    }
    return additionalData;
  }

  String? validateAdditionalFields() {
    for (var field in _additionalFields) {
      if (!field.isRequired) continue;

      if (field.fieldType == AdditionalFieldType.checkbox) {
        final value = _additionalFieldCheckValues[field.id];
        if (field.options?.isNotEmpty == true) {
          if (value is! List || value.isEmpty) {
            return field.title;
          }
        } else {
          if (value != true) {
            return field.title;
          }
        }
      } else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        final value = _additionalFieldCheckValues[field.id] as String?;
        if (value == null || value.isEmpty) {
          return field.title;
        }
      } else if (field.fieldType == AdditionalFieldType.file) {
        if (_additionalFieldFiles[field.id] == null || _additionalFieldFiles[field.id]!.isEmpty) {
          return field.title;
        }
      } else {
        final value = _additionalFieldControllers[field.id]?.text.trim() ?? '';
        if (value.isEmpty) {
          return field.title;
        }
      }
    }
    return null;
  }

  void disposeAdditionalFields() {
    for (var controller in _additionalFieldControllers.values) {
      controller.dispose();
    }
    for (var node in _additionalFieldFocusNodes.values) {
      node.dispose();
    }
    _additionalFieldControllers = {};
    _additionalFieldFocusNodes = {};
    _additionalFieldFiles = {};
    _additionalFieldCheckValues = {};
    _additionalFieldPhoneCountryCodes = {};
    additionalFiles = [];

  }


  // Future<void> socialLogout() async {
  //   final UserInfoModel? user = Provider.of<ProfileProvider>(Get.context!, listen: false).userInfoModel;
  //   if(user?.loginMedium?.toLowerCase() == SocialLoginOptionsEnum.google.name) {
  //     try{
  //       await signIn.signOut();
  //       await signIn.disconnect();
  //     }catch(e){
  //       log("Error: $e");
  //     }
  //
  //
  //   }else if(user?.loginMedium?.toLowerCase() == SocialLoginOptionsEnum.facebook.name) {
  //     await facebookAuth.logOut();
  //   }
  //
  // }


}