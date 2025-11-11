import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/notification_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/ui/admin/network/admin_repository.dart';
import 'package:localguider/user_role.dart';

import '../../../base/base_bloc.dart';
import '../../../base/base_callback.dart';
import '../../../models/response/admin_dashboard_dto.dart';
import '../../../network/repository/home_repository.dart';

class AdminBloc extends BaseBloc {
  fetchPhotographers(UserRole userRole, int page, String status,
      String searchText, Function(BaseListCallback<PhotographerDto>) callback) {
    showLoading();
    AdminRepository.getPhotographers(userRole, page, status, searchText, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  fetchPlaces(
      page, searchText, Function(BaseListCallback<PlaceModel>) callback) {
    showLoading();
    AdminRepository.getPlaces(page, searchText, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  adminDashboard(Function(BaseCallback<AdminDashboardDto>) callback) {
    showLoading();
    AdminRepository.adminDashboard( (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  respondToPhotographer(
      UserRole userRole, dtoId, status, reasonOfDecline, Function(BaseCallback<dynamic>) callback) {
    showLoading();
    AdminRepository.responsePhotographer(userRole, dtoId, status, reasonOfDecline, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  usersList(page, searchText, Function(BaseListCallback<UserData>) callback) {
    showLoading();
    AdminRepository.getUsers(page, searchText, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  void getAccountDetails(
      String? userId, Function(BaseCallback<UserData>) callback
      ) {
    showLoading();
    HomeRepository.getProfile(userId, (p0) {
      dismissLoading();
      callback.call(p0);
    });
  }

  void getPlacesByIds(String ids,
      Function(BaseListCallback<PlaceModel>) callback) {
    showLoading();
    HomeRepository.getPlacesByIds(ids, (p0) {
      dismissLoading();
      callback.call(p0);
    });
  }

  deleteUser(userId, Function(BaseCallback<dynamic>) callback) {
    showLoading();
    AdminRepository.deleteUser(userId, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

   deletePlace(placeId, Function(BaseCallback<dynamic>) callback) {
    showLoading();
    AdminRepository.deletePlace(placeId, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  download(endPoint, Function(BaseCallback<String>) callback) {
    showLoading();
    AdminRepository.download(endPoint, (p0) {
      callback(p0);
      dismissLoading();
    });
  }

  void getPhotographerDetails(UserRole userRole, String id, Function(BaseCallback<PhotographerDto>) callback) {
    showLoading();
    HomeRepository.getPhotographerOrGuiderDetails(userRole, id, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

  void sendNotification(title, description, isAll, isPhotographers, isGuiders, isVisitors, Function(BaseCallback<NotificationModel>) callback) {
    showLoading();
    HomeRepository.sendNotification(title, description, isAll, isPhotographers, isGuiders, isVisitors, (p0) {
      dismissLoading();
      callback(p0);
    });
  }

}
