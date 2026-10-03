import 'package:tatarigigs_user/common/models/api_response_model.dart';
import 'package:tatarigigs_user/common/repo/data_sync_repo.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class UserRepo extends DataSyncRepo{
  UserRepo({required super.apiClient, required SharedPreferences super.sharedPreferences});

  Future<ApiResponseModel<T>> getUserInfo<T> ({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.customerInfoUri, source);
  }

  Future<ApiResponseModel<T>> getCategoryList<T>({required DataSourceEnum source}) async {
    return await fetchData<T>('${AppConstants.categoryUrl}?limit=100&offset=1', source);
  }

  Future<Response> updateProfile(
      UserInfoModel userInfoModel, XFile? data,
      {Map<String, dynamic>? additionalData,
        List<MultipartBody>? additionalFiles,
        Map<String, dynamic>? oldAdditionalImages
      }) async {

    Map<String, String> body = {};
    body.addAll(<String, String>{
      '_method': 'put',
      'first_name': userInfoModel.fName!,
      'last_name': userInfoModel.lName!,
      'email': userInfoModel.email!,
      'phone': userInfoModel.phone!,
      'password': userInfoModel.password ?? "",
      'confirm_password': userInfoModel.confirmPassword ??"",
    });

    Map<String, String> bodyData = {};
    additionalData?.forEach((key, value){
      if(value is String){
        bodyData['additional_data[$key]'] = value;
      }else if(value is List<dynamic>){
        for(int i = 0 ; i< value.length ; i++){
          bodyData['additional_data[$key][$i]'] = value[i];
        }
      }
    });

    oldAdditionalImages?.forEach((key, value){
      for(int i = 0 ; i< value.length ; i++){
        bodyData['existing_additional_data[$key][$i]'] = value[i];
      }
    });

    List<MultipartBody> multipartList = [];
    multipartList.addAll(additionalFiles ?? []);
    if(data != null){
      multipartList.add(MultipartBody('profile_image', data));
    }

    return await apiClient.postMultipartData(
        AppConstants.updateProfileUri, body,
        multipartList, additionalData: bodyData
    );
  }

  Future<Response> changePassword(UserInfoModel userInfoModel) async {
    return await apiClient.postData(AppConstants.updateProfileUri, {'phone_or_email': userInfoModel.fName, 'otp': userInfoModel.lName,
      'password': userInfoModel.email, 'confirm_password': userInfoModel.phone});
  }

  Future<Response> deleteUser() async {
    return await apiClient.deleteData(AppConstants.customerRemove);
  }

}