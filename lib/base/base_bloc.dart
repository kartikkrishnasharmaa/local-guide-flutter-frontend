import 'dart:async';

import 'package:localguider/main.dart';

import '../models/requests/update_user_request_dto.dart';
import '../models/response/user_data.dart';
import '../network/repository/auth_repository.dart';
import '../ui/home/home.dart';
import 'base_callback.dart';

abstract class BaseBloc {
  final StreamController<bool> loadingController =
      StreamController<bool>.broadcast();

  final StreamController<String?> errorStream =
      StreamController<String?>.broadcast();

  final StreamController<String?> successStream =
      StreamController<String?>.broadcast();

  showLoading() {
    if(!loadingController.isClosed) loadingController.add(true);
  }

  dismissLoading() {
    if(!loadingController.isClosed) loadingController.add(false);
  }

  showError(String? error) {
    if(!errorStream.isClosed) errorStream.add(error ?? $strings.SOME_THING_WENT_WRONG);
  }

  successSnack(String? message) {
    if(!successStream.isClosed) successStream.add(message ?? $strings.SUCCESS);
  }

  void dispose() {
    if(!loadingController.isClosed) loadingController.close();
    if(!errorStream.isClosed) errorStream.close();
    if(!successStream.isClosed) successStream.close();
  }

  updateUserInfo(
      {required UpdateUserRequestDto request,
        required Function(BaseCallback<UserData>) callback,
        disableLoading = false}) async {
    if (!disableLoading) showLoading();
    AuthRepository.updateUser(request, (response) {
      dismissLoading();
      callback(response);
      Future.delayed(const Duration(milliseconds: 300), () {
        infoUpdated.add(true);
      });
    });
  }

}
