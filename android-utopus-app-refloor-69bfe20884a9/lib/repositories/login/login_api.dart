
import 'package:reflore/model/user_data.dart';

import '../../../model/base_response/request_response.dart';
import '../../common/utilites/logger.dart';
import '../base/base_api_service.dart';
import '../end_point/end_point.dart';

abstract class LoginAPI{

  Future<RequestResponse<UserData>> login(Map<String,dynamic> data,Map<String,dynamic> param);
}
class LoginService extends BaseAPIService implements LoginAPI{
  LoginService();

  @override
  Future<RequestResponse<UserData>> login(Map<String,dynamic> data,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.login, body: data,params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=UserData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }




}