import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:reflore/common/validators/validators.dart';
import 'package:reflore/di/app_injector.dart';
import 'package:reflore/di/i_dashboard_page.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/utilites/common_data.dart';
import '../../../common/utilites/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/user_data.dart';
import '../../../repositories/end_point/end_point.dart';
import '../../../repositories/login/login_api.dart';

typedef LoginFactory = BlocProvider<LoginBloc> Function();

class LoginBloc extends BlocBase {
  UserDataStore? userDataStore;
  final BehaviorSubject<String> _phone = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('');
  final BehaviorSubject<bool> _isSave = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _onClickButton = BehaviorSubject.seeded(false);
  BehaviorSubject<String?> phoneValidationData = BehaviorSubject<String>();
  BehaviorSubject<String?> passwordValidationData = BehaviorSubject<String>();
  BehaviorSubject<String> _errMsg = BehaviorSubject.seeded('');
  BehaviorSubject<bool> _valid = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _isVisible = BehaviorSubject.seeded(true);
  BehaviorSubject<bool> _isCheck = BehaviorSubject.seeded(false);
  Sink<bool> get addIsCheck => _isCheck;
  Stream<bool> get isCheck => _isCheck;
  Sink<bool> get addIsVisible => _isVisible;
  Stream<bool> get isVisible => _isVisible;
  PublishSubject<void> _proceed = PublishSubject();
  Stream<String?> get phoneValidation => phoneValidationData;
  Stream<String?> get passwordValidation => passwordValidationData;
  Stream<String> get errMsg => _errMsg;
  Sink<String> get addPhone => _phone;
  Sink<String> get password => _password;
  Stream<bool> get isSave => _isSave;
  Sink<bool> get addIsSave => _isSave;
  Stream<bool> get isLoading => _isLoading;

  Sink<void> get login => _proceed;
  Stream<bool> get onClickButton => _onClickButton;
  Sink<bool> get addOnClickButton => _onClickButton;
  bool isRemember = false;
  LoginBloc({this.userDataStore}) {
    _setListeners();
  }

  _setListeners() {
    _phone
        .map((e) => e.toLowerCase())
        .map(FormValidator().validateEmail)
        .listen(
      (event) {
        if (event != null) {
          printLog("title", event);
          phoneValidationData.add(event);
        } else {
          phoneValidationData.add("");
        }
      },
    ).addTo(disposeBag);

    _password
        .map((e) => e.toLowerCase())
        .map(FormValidator().validateField)
        .listen(
      (event) {
        if (event != null) {
          passwordValidationData.add(event);
        } else {
          passwordValidationData.add("");
        }
      },
    ).addTo(disposeBag);

    CombineLatestStream.combine2(phoneValidationData, passwordValidationData,
        (a, b) {
      return a == "" && b == "";
    }).listen(_valid.add).addTo(disposeBag);

    _proceed
        .withLatestFrom(_valid, (_, bool v) => v)
        .where((v) {
          printLog("_valid", v);
          return v;
        })
        .withLatestFrom2(
            _phone,
            _password,
            (
              t,
              String e,
              String p,
            ) =>
                {"LoginID": e, "Password": p})
        .listen(navigateData)
        .addTo(disposeBag);
  }

  void isSaveData(bool val) {
    _isSave.add(val);
    isRemember = val;
  }

  navigateData(Map<String, dynamic> data) async {
    // Get.to(AppInjector.instance.dashboard());
    if (await CommonData.checkConnectivity() != ConnectivityResult.none) {
      _isLoading.add(true);
      LoginService()
          .login(data, {'instance': EndPoints.env}).then((value) async {
        _isLoading.add(false);
        if (value.data != null) {
          await userDataStore!.insert(value.data!);

          Get.to(AppInjector.instance.dashboard());
        } else {
          if (value.error != null) {
            if (value.error!.errors != null) {
              if (value.error!.errors!.isNotEmpty) {
                _errMsg.add(value.error!.errors![0].message!);
                printLog("error message", value.error!.errors![0].message);
              }
            } else {
              _errMsg.add(value.error!.error!);
              printLog("error message", value.error!.error);
            }
          }
        }
      });
    } else {
      _errMsg.add('No Internet Connection!');
    }
  }
}
