

import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/model/checklist_data.dart';
import 'package:reflore/model/invoice_data.dart';

import '../../../model/base_response/request_response.dart';
import '../../model/appointment_data.dart';
import '../../model/work_flow.dart';
import '../base/base_api_service.dart';
import '../end_point/end_point.dart';
import 'package:dio/dio.dart';


abstract class DashboardAPI{

  Future<RequestResponse<List<ChecklistData>>> getCheckList(String token,Map<String,dynamic> param);
  Future<RequestResponse<InvoiceData>> getInvoiceDetails(String token,Map<String,dynamic> param);
  Future<RequestResponse<InvoiceData>> sendInvoiceAmount(String token,Map<String,dynamic> param);


  Future<RequestResponse<List<AppointmentData>>> appointmentDetails(String token,Map<String,dynamic> param);
  Future<RequestResponse<AppointmentData>> confirmInstall(String token,Map<String,dynamic> param);
  Future<RequestResponse<List<dynamic>>> getReleasedInstallations(String token,Map<String,dynamic> param);
  Future<RequestResponse<AppointmentData>> confirmArrival(String token,Map<String,dynamic> param);
  Future<RequestResponse<AppointmentData>> imageUpload(String token,Map<String,dynamic> param,FormData farmDat);
  Future<RequestResponse<AppointmentData>> createInstallSummary(String token,Map<String,dynamic> param);
  Future<RequestResponse<WorkFlow>> lightCoWorkFlow(Map<String,dynamic> body,Map<String,dynamic> param);
  Future<RequestResponse<AppointmentData>> jobCompletionCertificate(Map<String,dynamic> body,Map<String,dynamic> param);


}
class DashboardService extends BaseAPIService implements DashboardAPI{
  DashboardService();

  @override
  Future<RequestResponse<List<AppointmentData>>> appointmentDetails(String token,Map<String,dynamic> param) {
    return make(RequestType.GET, EndPoints.appointmentDetails(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        List dynamicList =
        result.data.map((c) => AppointmentData.fromJson(c)).toList();
        List<AppointmentData> appointments = List<AppointmentData>.from(dynamicList);
        return RequestResponse(data: appointments);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<List<ChecklistData>>> getCheckList(String token,Map<String,dynamic> param) {
    return make(RequestType.GET, EndPoints.getCheckList(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        List dynamicList =
        result.data.map((c) => ChecklistData.fromJson(c)).toList();
        List<ChecklistData> appointments = List<ChecklistData>.from(dynamicList);
        return RequestResponse(data: appointments);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  Future<RequestResponse<InvoiceData>> getInvoiceDetails(String token,Map<String,dynamic> param) {
    return make(RequestType.GET, EndPoints.getInvoiceDetails(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        return RequestResponse(data: InvoiceData.fromJson(result.data));
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  Future<RequestResponse<InvoiceData>> sendInvoiceAmount(String token,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.sendInvoiceAmount(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        return RequestResponse(data: InvoiceData.fromJson(result.data));
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }



  @override
  Future<RequestResponse<AppointmentData>> confirmInstall(String token,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.confirmInstall(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=AppointmentData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<List<dynamic>>> getReleasedInstallations(String token,Map<String,dynamic> param) {
    return make(RequestType.GET, EndPoints.getReleasedInstallations(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        return RequestResponse(data: result.data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<AppointmentData>> confirmArrival(String token,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.confirmArrival(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=AppointmentData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }


  @override
  Future<RequestResponse<AppointmentData>> imageUpload(String token, param,FormData farmDat) {
    return makeDio(RequestType.POST, EndPoints.imageUpload(token),params: param,body:farmDat,contentType: ContentType.multipart)
        .then((result) {
      if (result.data != null) {
        printLog("result.data", result.data);
        var data=AppointmentData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("result.error", result.error);
        return RequestResponse(error: result.error);
      }
    });
  }


  @override
  Future<RequestResponse<AppointmentData>> createInstallSummary(String token,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.createInstallSummary(token),params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=AppointmentData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<WorkFlow>> lightCoWorkFlow(Map<String,dynamic> body,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.lightCoWorkFlow,params: param,body:body,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=WorkFlow.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }




  @override
  Future<RequestResponse<AppointmentData>> jobCompletionCertificate(Map<String,dynamic> body,Map<String,dynamic> param) {
    return make(RequestType.POST, EndPoints.jobCompletionCertificate,body: body,params: param,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        var data=AppointmentData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }
}