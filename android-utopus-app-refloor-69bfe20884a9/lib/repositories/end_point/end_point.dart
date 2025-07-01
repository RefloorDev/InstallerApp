class EndPoint {
  final String base;
  final String path;

  EndPoint({required this.base, required this.path});
}

class EndPoints {

  static String _devBase = "myx.ac";

  // prod myx.ac
  // dev https://dev.myx.ac/LighticoAPI

  static String get _base {return _devBase;}

  static const  _api = '/I360/';
  static const  _subApi = '/LighticoAPI/';
  static const  env = 'sandbox';
  static const refloor_auth='cmVmbG9vcmxsYy1XSDhaQjcuNjRXS09EOjE2MDczZmQ1LTE4M2QtNDQzNS04MTZjLWFhMGVmODNlY2ZkYw==/';


  //login user
  static EndPoint get login => _getEndPointWithPath('${_api}AuthenticateStaff');

  //GetAppointmentDetails
  static EndPoint  appointmentDetails(String token) => _getEndPointWithPath('${_api}GetAppointments/refloor_auth=$token');
  //confirm installation
  static EndPoint  confirmInstall(String token) => _getEndPointWithPath('${_api}ConfirmInstall/refloor_auth=$token');
  //confirm Arrival
  static EndPoint  confirmArrival(String token) => _getEndPointWithPath('${_api}ConfirmArrival/refloor_auth=$token');

  //imageUpload
  static EndPoint  imageUpload(String token) => _getEndPointWithPath('${_api}PhotoUpload/refloor_auth=$token');

  // SendInstallerText
  static EndPoint  sendInstallerText(String token) => _getEndPointWithPath('${_api}SendInstallerText/refloor_auth=$token');

  //Secondary (or more) phone number(s) of ICMs, Ops manager, field ops managers
  static EndPoint  getReleasedInstallations(String token) => _getEndPointWithPath('${_api}GetReleasedInstallations/refloor_auth=$token');

  //CreateInstallSummary
  static EndPoint  createInstallSummary(String token) => _getEndPointWithPath('${_api}CreateInstallSummary/refloor_auth=$token');
  //LighticoWorkflow
  static EndPoint get lightCoWorkFlow => _getEndPointWithPath('${_subApi}LighticoWorkflow');
  //JobCompletionCertificate
  static EndPoint get jobCompletionCertificate => _getEndPointWithPath('${_subApi}JobCompletionCertificate');
  // checklist Data
  static EndPoint  getCheckList(String token) => _getEndPointWithPath('${_api}GetArrivalCompletionChecklist/refloor_auth=$token');
  //Get InvoiceDetails
  static EndPoint  getInvoiceDetails(String token) => _getEndPointWithPath('${_api}GetInvoiceDetails/refloor_auth=$token');

  static EndPoint  sendInvoiceAmount(String token) => _getEndPointWithPath('${_api}UploadInstallerInvoice/refloor_auth=$token');


  static EndPoint _getEndPointWithPath(String path) {
    return EndPoint(base: _base, path: path);
  }




  }
