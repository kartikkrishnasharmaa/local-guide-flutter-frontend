import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/user_role.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_libs.dart';
import '../components/component_util.dart';
import '../components/custom_ink_well.dart';
import '../components/custom_text.dart';
import '../components/loading.dart';
import '../main.dart';
import '../models/response/user_data.dart';
import '../responsive.dart';
import 'base_bloc.dart';

mixin PostFrameMixin<T extends StatefulWidget> on State<T> {
  void postFrames(void Function() callback) =>
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          if (mounted) callback();
        },
      );
}


abstract class BaseState<T extends StatefulWidget, B extends BaseBloc>
    extends State<T> with AutomaticKeepAliveClientMixin, PostFrameMixin<T>  {
  Widget view();

  B setBloc();
  void postFrame() { }

  void init();

  bool isKeepAlive() {
    return true;
  }

  var disableDialogLoading = false;

  final ImagePicker _picker = ImagePicker();

  UserData get user => $user.getUser() ?? UserData();

  UserRole getUserRole() {
    if(user.gid != null) {
      return UserRole.GUIDER;
    } else if(user.pid != null) {
      return UserRole.PHOTOGRAPHER;
    }
    return UserRole.JUST_USER;
  }

  String? getDtoId() {
    if(getUserRole() == UserRole.PHOTOGRAPHER) {
      return user.pid?.toString();
    } else if(getUserRole() == UserRole.GUIDER) {
      return user.gid?.toString();
    } else {
      return user.id.toString();
    }
  }

  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iosDeviceInfo;

  void observer() {
    bloc.loadingController.stream.listen((event) {
      if (!disableDialogLoading) {
        if (event) {
          showLoading();
        } else {
          dismissLoading();
        }
      } else {
        dismissLoading();
      }
    });

    bloc.errorStream.stream.listen((event) {
      if (event != null) {
        snackBar($strings.error, event);
      }
    });

    bloc.successStream.stream.listen((event) {
      if (event != null) {
        snackBar($strings.success, event);
      }
    });
  }

  late B bloc;

  @override
  void initState() {
    super.initState();
    bloc = setBloc();
    disableDialogLoading = false;
    postFrames(() {
      postFrame();
    });
    init();
    observer();
    _deviceInfo();
  }

  _deviceInfo() async {
    if (Platform.isAndroid) {
      androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    }
    if (Platform.isIOS) iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return view();
  }

  showLoading() {
    Loading.show(context);
  }

  dismissLoading() {
    Loading.hide(context);
  }

  onResponseError({String? msg}) {
    $appUtils.snackBar(msg ?? "Something went wrong", context);
  }

  toast(String msg) {
    $appUtils.snackBar(msg, context);
  }

  pickImageDialog(
      Function(bool success, String message, XFile? image) callback, {useCamera = true}) {
    if(kIsWeb) {
      _pickImage(callback);
      return;
    }
    if(!useCamera) {
      _pickImage(callback);
    } else {
      checkPermissions(context, Permission.camera, (p0) {
        if (p0) {
          checkPermissions(
              context,
              ((androidDeviceInfo?.version.sdkInt ?? 0) > 32 || Platform.isIOS)
                  ? Permission.photos
                  : Permission.storage, (p0) {
            if (p0) {
              _showPickImageDialog(callback);
            } else {
              callback(false, $strings.PERMISSION_DENIED, null);
            }
          });
        } else {
          callback(false, $strings.PERMISSION_DENIED, null);
        }
      });
    }
  }

  _showPickImageDialog(Function(bool success, String message, XFile? image) callback) {
    showAlertDialog(
        title: Center(
            child: CustomText(
              "Choose Image",
              fontSize: sizing(16, context),
              color: $styles.colors.title,
              isBold: true,
            )),
       dialog: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInkWell(
                onTap: () {
                  _pickImage(callback);
                  navigatePop(context);
                },
                child: Padding(
                  padding: padding(10),
                  child: CustomText(
                    "Pick Image from Gallery",
                    color: $styles.colors.title,
                  ),
                )),
            CustomInkWell(
                onTap: () {
                  _takeImage(callback);
                  navigatePop(context);
                },
                child: Padding(
                  padding: padding(10),
                  child: CustomText("Take Image",
                      color: $styles.colors.title),
                )),
          ],
        ));
  }

  _pickImage(
      Function(bool success, String message, XFile? image) callback) async {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        callback(true, "", value);
      } else {
        callback(false, $strings.SOME_THING_WENT_WRONG, null);
      }
    }, onError: (error, stackTrace) {
      callback(false, error?.toString() ?? $strings.SOME_THING_WENT_WRONG, null);
    });
  }

  _takeImage(
      Function(bool success, String message, XFile? image) callback) async {
    _picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        callback(true, "", value);
      } else {
        callback(false, $strings.SOME_THING_WENT_WRONG, null);
      }
    }, onError: (error, stackTrace) {
      callback(false, error?.toString() ?? $strings.SOME_THING_WENT_WRONG, null);
    });
  }

  showAlertDialog({required title, required Widget dialog, barrierDismissible = true}) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return AlertDialog(
            title: title,
            backgroundColor: $styles.colors.white,
            content: dialog,
          );
        });
  }

  checkPermissions(
      context, Permission permission, Function(bool) callback) async {
    var status = await permission.status;
    if (status.isGranted) {
      callback(true);
    } else {
      _requestPermission(permission, callback);
    }
  }

  _requestPermission(Permission permission, Function(bool) callback) async {
    if (await permission.request().isGranted) {
      callback(true);
    } else {
      callback(false);
    }
  }

  @override
  bool get wantKeepAlive => isKeepAlive();

  @override
  void dispose() {
    disableDialogLoading = false;
    bloc.loadingController.close();
    bloc.dispose();
    super.dispose();
  }
}
