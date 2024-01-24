import 'package:edriving_spim_app/common_library/services/model/student_model.dart';
import 'package:edriving_spim_app/common_library/services/networking.dart';
import 'package:edriving_spim_app/common_library/services/response.dart';
import 'package:edriving_spim_app/common_library/utils/local_storage.dart';
import 'package:edriving_spim_app/utils/app_config.dart';

class StudRepo{
  final appConfig = AppConfig();
  final localStorage = LocalStorage();
  final networking = Networking();

  Future<Response> getStudent({
    required context,
    searchBy,
    searchValue
  }) async {
    String? caUid = await localStorage.getCaUid();
    String? caPwd = await localStorage.getCaPwd();
    String? merchantNo = await localStorage.getMerchantDbCode();

    String path = 
        'wsCodeCrypt=${appConfig.wsCodeCrypt}&caUid=$caUid&caPwd=$caPwd&merchantNo=$merchantNo&searchBy=$searchBy&searchValue=$searchValue';

    var response = await networking.getData(
      path: 'GetStudentByKeywordV2?$path',
    );

    if (response.isSuccess && response.data != null) {
      GetStudentResponse getStudentResponse =
          GetStudentResponse.fromJson(response.data);


      return Response(true, data: getStudentResponse.studentList);
    }
    return Response(false, message: response.message);
  }
}