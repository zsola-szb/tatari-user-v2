import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/feature/auth/model/additional_field_model.dart';
import 'package:tatarigigs_user/helper/country_code_helper.dart';
import 'package:tatarigigs_user/helper/data_sync_helper.dart';
import 'package:tatarigigs_user/helper/file_validation_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedProfileImageFile ;
  XFile? get pickedProfileImageFile => _pickedProfileImageFile;

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  var countryDialCode = "+880";

  final int _year = 0;
  int get year => _year;

  final int _month = 0;
  int get month => _month;

  final int _day = 0;
  int get day => _day;
  final now = DateTime.now();
  String _createdAccountAgo ='';
  String get createdAccountAgo => _createdAccountAgo;

  String _userProfileImage = '';
  String get userProfileImage => _userProfileImage;

  var editProfilePageCurrentState = EditProfileTabControllerState.generalInfo;

  ///For Additional Data update
  List<AdditionalFieldModel> _additionalFields = [];
  List<AdditionalFieldModel> get additionalFields => _additionalFields;

  Map<String, TextEditingController> _additionalFieldControllers = {};
  Map<String, TextEditingController> get additionalFieldControllers => _additionalFieldControllers;

  Map<String, FocusNode> _additionalFieldFocusNodes = {};
  Map<String, FocusNode> get additionalFieldFocusNodes => _additionalFieldFocusNodes;
  Map<String, List<dynamic>> _additionalFieldFiles = {};
  Map<String, List<dynamic>> get additionalFieldFiles => _additionalFieldFiles;
  Map<String, dynamic> _additionalFieldCheckValues = {};
  Map<String, dynamic> get additionalFieldCheckValues => _additionalFieldCheckValues;
  Map<String, String> _additionalFieldPhoneCountryCodes = {};
  Map<String, String> get additionalFieldPhoneCountryCodes => _additionalFieldPhoneCountryCodes;

  final Map<String, dynamic> additionalData = {};
  List<MultipartBody> additionalFiles = [];
  Map<String, dynamic> oldAdditionalImages = {};

  UserInfoModel? setUserInfoModelData(UserInfoModel? userInfoModel) => _userInfoModel = userInfoModel;

  Future<void> getUserInfo({bool reload = true}) async {

    if(reload || _userInfoModel == null){
      _userInfoModel = null;
    }

    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: ()=> userRepo.getUserInfo<CacheResponseData>( source: DataSourceEnum.local),
      fetchFromClient: ()=>userRepo.getUserInfo(source: DataSourceEnum.client),
      onResponse: (data, source) {
        if(source == DataSourceEnum.client){
          _userInfoModel = UserInfoModel.fromJson(data['content']);
          _userProfileImage = _userInfoModel?.image??"";
          final difference= now.difference(DateConverter.isoUtcStringToLocalDate(data['content']['created_at']));
          _createdAccountAgo =  timeago.format(now.subtract(difference));

          update();
        }
      },
    );
  }

  bool showReferWelcomeDialog(){

    if( _userInfoModel != null && _userInfoModel!.referredBy !=null && _userInfoModel!.bookingsCount!=null && _userInfoModel!.bookingsCount! < 1){
      return true;
    }else{
      return false;
    }


  }


  Future removeUser() async {
    _isLoading = true;
    update();
    Response response = await userRepo.deleteUser();
    _isLoading = false;
    if(response.statusCode == 200){
      customSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.find<AuthController>().googleLogout();
      Get.find<AuthController>().signOutWithFacebook();
      Get.offAllNamed(RouteHelper.getInitialRoute());
    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }
  }


  void pickProfileImage() async {
    _pickedProfileImageFile = await FileValidationHelper.validateAndPickImage(
      source: ImageSource.gallery,
    );
    update();
  }

  Future<void> removeProfileImage() async {
    _pickedProfileImageFile = null;
  }


  void updateEditProfilePage(EditProfileTabControllerState editProfileTabControllerState, {bool shouldUpdate = true}){
    editProfilePageCurrentState = editProfileTabControllerState;
    if(shouldUpdate){
      update();
    }
  }

  Future<void> updateUserProfile({required UserInfoModel userInfoModel}) async {

    _isLoading = true;
    update();

    await getAdditionalFieldValues();

    Response response = await userRepo.updateProfile(
        userInfoModel, pickedProfileImageFile,
      additionalData: additionalData, additionalFiles: additionalFiles, oldAdditionalImages: oldAdditionalImages
    );

    if (response.body['response_code'] == 'default_update_200') {
      customSnackBar('${response.body['response_code']}'.tr, type : ToasterMessageType.success, showDefaultSnackBar: false);
    }else{
      ApiChecker.checkApi(response);
    }
    await Get.find<UserController>().getUserInfo(reload: false);
    _isLoading = false;
    update();

  }

  void loadAdditionalFields() {
    _additionalFields = Get.find<SplashController>().configModel.content?.additionalFieldList ?? [];

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

          _userInfoModel?.additionalData?.forEach((additionData){
            if(additionData.title == field.title && additionData.type == field.fieldType.name){
              _additionalFieldCheckValues[field.id] = additionData.value ?? [];
            }
          });
        } else {
          _additionalFieldCheckValues[field.id] = false;

          _userInfoModel?.additionalData?.forEach((additionData){
            if(additionData.title == field.title && additionData.type == field.fieldType.name){
              _additionalFieldCheckValues[field.id] = (additionData.value?.isNotEmpty == true && additionData.value![0] == '1');
            }
          });
        }
      }
      else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        _additionalFieldCheckValues[field.id] = '';

        _userInfoModel?.additionalData?.forEach((additionData){
          if(additionData.title == field.title && additionData.type == field.fieldType.name){
            _additionalFieldCheckValues[field.id] = additionData.value?[0] ?? '';
          }
        });
      }
      else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id] = [];

        _userInfoModel?.additionalData?.forEach((additionData){
          if(additionData.title == field.title && additionData.type == field.fieldType.name){
            additionData.value?.forEach((v) {
              _additionalFieldFiles[field.id]?.add(v);
            });
          }
        });
      } else {
        _additionalFieldFocusNodes[field.id] = FocusNode();
        _additionalFieldControllers[field.id] = TextEditingController();
        if (field.fieldType == AdditionalFieldType.phone) {
          _additionalFieldPhoneCountryCodes[field.id] = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? 'BD').dialCode ?? '+880';
        }

        _userInfoModel?.additionalData?.forEach((additionData){
          if(additionData.title == field.title && additionData.type == field.fieldType.name){
            String phoneWithCountry = additionData.value?[0] ?? '';
            if (field.fieldType == AdditionalFieldType.phone && phoneWithCountry.isNotEmpty) {
              String? countryCode = CountryCodeHelper.getCountryCode(phoneWithCountry);
              if (countryCode != null) {
                _additionalFieldPhoneCountryCodes[field.id] = countryCode;
                _additionalFieldControllers[field.id]?.text = phoneWithCountry.substring(countryCode.length);
              } else {
                _additionalFieldControllers[field.id]?.text = phoneWithCountry;
              }
            } else {
              _additionalFieldControllers[field.id]?.text = phoneWithCountry;
            }
          }
        });
      }
    }
  }

  void setAdditionalFieldFile(String fieldId, List<dynamic> files) {
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
    additionalData.clear();
    oldAdditionalImages.clear();
    for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox || field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        additionalData[field.title] = _additionalFieldCheckValues[field.id] ?? (field.options?.isNotEmpty == true ? [] : false);
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id]?.forEach((file){
          if(file is XFile){
            additionalFiles.add(MultipartBody('additional_data[${field.title}][]', file));
          }else if(file is String){
            if (oldAdditionalImages[field.title] == null) {
              oldAdditionalImages[field.title] = <String>[];
            }
            oldAdditionalImages[field.title].add(file);
          }

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
    oldAdditionalImages = {};
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

}

