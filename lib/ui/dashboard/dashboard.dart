import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/style/colors.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/authentication/user_information.dart';
import 'package:localguider/ui/dashboard/appointment_requests.dart';
import 'package:localguider/ui/dashboard/appointment_requests_main_page.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/ui/home/home.dart';
import 'package:localguider/ui/payments/add_payment.dart';
import 'package:localguider/ui/payments/transactions.dart';
import 'package:localguider/ui/payments/withdrawals.dart';
import 'package:localguider/ui/reviews/all_reviews.dart';
import 'package:localguider/ui/reviews/review_on_details.dart';
import 'package:localguider/ui/services/services_list.dart';
import 'package:localguider/ui/settings/notifications.dart';
import 'package:localguider/ui/settings/settings.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/values/assets.dart';
import '../../base/base_callback.dart';
import '../../components/app_image.dart';
import '../../main.dart';
import '../../models/response/appointment_response.dart';
import '../../responsive.dart';
import '../gallery/all_images.dart';
import '../privacy/simple_text_viewer.dart';
import '../settings/blocked.dart';

StreamController<bool> refreshDashboardAppointments =
    StreamController.broadcast();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends BaseState<Dashboard, HomeBloc> {
  PhotographerDto? _photographerDto;
  UserRole _userRole = UserRole.PHOTOGRAPHER;
  String? _dtoId;

  List<AppointmentResponse> requestedAppointments = [];
  List<AppointmentResponse> onGoingAppointments = [];
  final PagingController<int, AppointmentResponse>
      _requestedAppointmentsPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, AppointmentResponse>
      _onGoingAppointmentsPagingController = PagingController(firstPageKey: 1);

  @override
  void init() {
    if (user.gid != null) {
      _userRole = UserRole.GUIDER;
      _dtoId = user.gid.toString();
    } else {
      _userRole = UserRole.PHOTOGRAPHER;
      _dtoId = user.pid.toString();
    }
    _getData();
    _getSettings();

    _requestedAppointmentsPagingController.addPageRequestListener((pageKey) {
      bloc.getAppointments(getUserRole(), getDtoId()!,
          AppointmentStatus.requested, 1, "", _handleRequestedResponse);
    });
    _onGoingAppointmentsPagingController.addPageRequestListener((pageKey) {
      bloc.getAppointments(getUserRole(), getDtoId()!,
          AppointmentStatus.onGoing, 1, "", _handleOnGoingResponse);
    });

  }

  _getData() {
    bloc.showLoading();
    bloc.getPhotographerDetails(_userRole, _dtoId!, (p0) {
      disableDialogLoading = false;
      bloc.dismissLoading();
      $logger.log(message: "message>>>> Photographer   ${p0.data.toString()}");
      setState(() {
        _photographerDto = p0.data;
      });
    });
    bloc.getProfile(user.id.toString());
    _getAppointments();
  }


  int unreadNotifications = 0;

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    $logger.log(message: "message>>>> UserId   ${user.toJson()}");
    return Container(
      color: $styles.colors.blueBg,
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  gap(context, height: 40),
                  Opacity(
                      opacity: .30,
                      child: Image.asset(
                        Images.icWorldTravels,
                        color: $styles.colors.greyLight,
                      )),
                ],
              )),
          Scaffold(
            backgroundColor: colorTransparent,
            appBar: AppBar(
              backgroundColor: colorTransparent,
              automaticallyImplyLeading: false,
              toolbarHeight: sizing(60, context),
              title: Row(
                children: [
                  gap(context, width: 7),
                  InkWell(
                    onTap: () {
                      navigate(const Home());
                    },
                    child: ProfileView(
                        diameter: 50,
                        strokeGap: 0,
                        outerStrokeWidth: 0,
                        innerStrokeWidth: 2,
                        innerStrokeColor: $styles.colors.blue,
                        profileUrl: user.profile.appendRootUrl()),
                  ),
                  const Spacer(),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navigate(Notifications(
                        userRole: _userRole,
                        dtoId: _dtoId!,
                        refreshCallback: () {
                          _getSettings();
                        },
                      ));
                    },
                    icon: unreadNotifications > 0
                        ? Badge(
                            label: Text(unreadNotifications.toString()),
                            child: Icon(
                              Icons.notifications,
                              color: $styles.colors.blue,
                            ),
                          )
                        : Icon(
                            Icons.notifications,
                            color: $styles.colors.blue,
                          )),
                IconButton(
                    onPressed: () {
                      _menu(context);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: $styles.colors.blue,
                    )),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _getData();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(sizing(15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gap(context, height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Hey!",
                                  fontSize: titleSize(),
                                  style: FontStyles.medium,
                                  isBold: true,
                                  color: $styles.colors.blue,
                                ),
                                gap(context, height: 7),
                                CustomText(_photographerDto?.firmName ?? "",
                                    style: FontStyles.medium,
                                    isBold: true,
                                    maxLines: 2,
                                    fontSize: titleSize(),
                                    color: $styles.colors.blue),
                              ],
                            ),
                          ),
                          gap(context, width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                (_photographerDto?.rating ?? 0.0)
                                    .toStringAsFixed(1),
                                fontSize: titleSize(),
                                style: FontStyles.medium,
                                isBold: true,
                                color: $styles.colors.blue,
                              ),
                              gap(context, height: 7),
                              RatingBar.builder(
                                initialRating:
                                    _photographerDto?.rating?.toDouble() ?? 0.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                ignoreGestures: true,
                                itemSize: sizing(25, context),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      gap(context, height: 15),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(sizing(20, context)),
                        decoration: BoxDecoration(
                            color: $styles.colors.blue,
                            borderRadius:
                                BorderRadius.circular(sizing(20, context))),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_balance_wallet_rounded,
                                    color: $styles.colors.white),
                                gap(context, width: 10),
                                CustomText(
                                  "Balance: ",
                                  fontSize: sizing(20, context),
                                  isBold: true,
                                  color: $styles.colors.white,
                                ),
                                const Spacer(),
                                CustomText(
                                  "₹ ${(_photographerDto?.balance ?? 0.0).toStringAsFixed(2)}",
                                  fontSize: sizing(20, context),
                                  isBold: true,
                                  color: $styles.colors.white,
                                ),
                              ],
                            ),
                            gap(context, height: 10),
                            Row(
                              children: [
                                CustomText(
                                  "Accepting Appointments",
                                  fontSize: sizing(16, context),
                                  isBold: true,
                                  color: $styles.colors.white,
                                ),
                                const Spacer(),
                                CupertinoSwitch(
                                    value: _photographerDto?.active == true,
                                    thumbColor: _photographerDto?.active == true
                                        ? $styles.colors.green
                                        : $styles.colors.red,
                                    trackColor: _photographerDto?.active == true
                                        ? $styles.colors.green.withAlpha(50)
                                        : $styles.colors.red.withAlpha(50),
                                    onChanged: (newValue) {
                                      _changeActiveStatus(newValue);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      gap(
                        context,
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigate(Transactions(userRole: _userRole));
                              },
                              child: Center(
                                child: Material(
                                  elevation: 3,
                                  borderRadius:
                                      BorderRadius.circular(sizing(25, context)),
                                  child: SizedBox(
                                    height: sizing(55, context),
                                    width: sizing(55, context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          sizing(25, context)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(sizing(5, context)),
                                        child: AppImage(
                                            image: AssetImage(
                                                Images.icTransactions)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigate(Withdrawals(
                                  userRole: _userRole,
                                  dto: _photographerDto!,
                                  refreshCallback: () {
                                    disableDialogLoading = true;
                                    bloc.getPhotographerDetails(
                                        _userRole, _dtoId!, (p0) {
                                      disableDialogLoading = false;
                                      setState(() {
                                        _photographerDto = p0.data;
                                      });
                                    });
                                  },
                                ));
                              },
                              child: Center(
                                child: Material(
                                  elevation: 3,
                                  borderRadius:
                                      BorderRadius.circular(sizing(25, context)),
                                  child: SizedBox(
                                    height: sizing(55, context),
                                    width: sizing(55, context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          sizing(25, context)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(sizing(5, context)),
                                        child: AppImage(
                                            image: AssetImage(
                                                Images.icCashWithdrawal)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigate(AllImages(
                                  title:
                                      "Images by ${_photographerDto?.firmName}",
                                  userRole: _userRole,
                                  dtoId: _photographerDto?.id.toString() ?? "",
                                  canEdit: true,
                                ));
                              },
                              child: Center(
                                child: Material(
                                  elevation: 3,
                                  borderRadius:
                                      BorderRadius.circular(sizing(25, context)),
                                  child: SizedBox(
                                    height: sizing(55, context),
                                    width: sizing(55, context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          sizing(25, context)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(sizing(5, context)),
                                        child: AppImage(
                                            image: AssetImage(Images.icGallery)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomInkWell(
                              onTap: () {
                                navigate(const Settings());
                              },
                              child: Center(
                                child: Material(
                                  elevation: 3,
                                  borderRadius:
                                      BorderRadius.circular(sizing(25, context)),
                                  child: SizedBox(
                                    height: sizing(55, context),
                                    width: sizing(55, context),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          sizing(25, context)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(sizing(5, context)),
                                        child: AppImage(
                                            image: AssetImage(
                                                Images.icAccountSetting_64)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap(context, height: sizing(10, context)),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: CustomText("Transactions",
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(12, context),
                                  color: $styles.colors.blue),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: CustomText("Withdrawal",
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(12, context),
                                  color: $styles.colors.blue),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: CustomText("Gallery",
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(12, context),
                                  color: $styles.colors.blue),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: CustomText("Settings",
                                  isBold: true,
                                  maxLines: 1,
                                  fontSize: sizing(12, context),
                                  color: $styles.colors.blue),
                            ),
                          ),
                        ],
                      ),
                      gap(context, height: 15),
                      divider(color: $styles.colors.blue, thickness: .5),
                      gap(context, height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: $styles.colors.blue,
                          ),
                          gap(context, width: 10),
                          CustomText(
                              "Total Appointments: ${(requestedAppointments.length)}",
                              isBold: true,
                              fontSize: sizing(20, context),
                              color: $styles.colors.blue),
                        ],
                      ),
                      gap(context, height: 10),
                      divider(color: $styles.colors.blue, thickness: .5),
                      gap(context, height: 15),
                      Row(
                        children: [
                          CustomText("Requested Appointment",
                              color: $styles.colors.blue,
                              isBold: true,
                              fontSize: sizing(16, context)),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                navigate(AppointmentRequestsMainPage(
                                  initialStatus: AppointmentStatus.requested,
                                  dto: _photographerDto,
                                  refreshCallback: () {
                                    setState(() {});
                                  },
                                ));
                              },
                              child: CustomText("View All",
                                  color: $styles.colors.blue,
                                  isBold: true,
                                  fontSize: sizing(16, context))),
                        ],
                      ),
                      gap(context, height: 10),
                      AppointmentRequests(
                        status: AppointmentStatus.requested,
                        bloc: bloc,
                        dto: _photographerDto,
                        pagingController: _requestedAppointmentsPagingController,
                      ),
                      gap(context, height: 10),
                      Row(
                        children: [
                          CustomText("On Going Appointments",
                              color: $styles.colors.blue,
                              isBold: true,
                              fontSize: sizing(16, context)),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                navigate(AppointmentRequestsMainPage(
                                  initialStatus: AppointmentStatus.onGoing,
                                  dto: _photographerDto,
                                  refreshCallback: () {
                                    setState(() {});
                                  },
                                ));
                              },
                              child: CustomText("View All",
                                  color: $styles.colors.blue,
                                  isBold: true,
                                  fontSize: sizing(16, context))),
                        ],
                      ),
                      gap(context, height: 10),
                      AppointmentRequests(
                        bloc: bloc,
                        dto: _photographerDto,
                        status: AppointmentStatus.onGoing,
                        pagingController: _onGoingAppointmentsPagingController,
                      ),
                      gap(context, height: 10),
                      Row(
                        children: [
                          CustomText("My Reviews",
                              color: $styles.colors.blue,
                              isBold: true,
                              fontSize: sizing(16, context)),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                navigate(AllReviews(
                                  photographerId:
                                      _userRole == UserRole.PHOTOGRAPHER
                                          ? _dtoId
                                          : null,
                                  guiderId: _userRole == UserRole.GUIDER
                                      ? _dtoId
                                      : null,
                                ));
                              },
                              child: CustomText("View All",
                                  color: $styles.colors.blue,
                                  isBold: true,
                                  fontSize: sizing(16, context))),
                        ],
                      ),
                      ReviewOnDetails(
                        showInDashboard: true,
                        photographerId:
                            _userRole == UserRole.PHOTOGRAPHER ? _dtoId : null,
                        guiderId: _userRole == UserRole.GUIDER ? _dtoId : null,
                        onRatingChange: (newRating) {
                          setState(() {
                            _photographerDto?.rating = newRating;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _menu(context) {
    showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(400, 60, 10, 10),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: CustomText("Add Balance"),
            onTap: () {
              navigate(AddPayment(
                photographerId:
                    _userRole == UserRole.PHOTOGRAPHER ? _dtoId : null,
                guiderId: _userRole == UserRole.GUIDER ? _dtoId : null,
                callback: (b, a) {
                  if (b) {
                    setState(() {
                      _photographerDto?.balance =
                          (_photographerDto?.balance?.toDouble() ?? 0.0) + a;
                    });
                  }
                },
              ));
            },
          ),
          PopupMenuItem(
            child: CustomText("Services & Plans"),
            onTap: () {
              navigate(
                  ServicesList(dto: _photographerDto!, userRole: _userRole));
            },
          ),
          PopupMenuItem(
            child: CustomText("Manage Account"),
            onTap: () {
              navigate(UserInformation(
                phone: "",
                password: "",
                userData: user,
                isEditProfile: true,
                onUpdate: (user) {
                  $user.saveDetails(user);
                  _getData();
                },
              ));
            },
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            onTap: () {
              _showSocialPopupMenu(context);
            },
            child: CustomText("We are social"),
          ),
          PopupMenuItem(
            child: CustomText("Other"),
            onTap: () {
              _showOthersPopupMenu(context);
            },
          ),
          PopupMenuItem(
            child: CustomText("Log Out"),
            onTap: () {
              $appUtils.logOut(context);
            },
          ),
        ]);
  }

  void _showSocialPopupMenu(BuildContext context) async {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(400, 60, 10, 10),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: CustomText("Whatsapp"),
          onTap: () {
            $appUtils.openUrl(
                "https://wa.me/91${$appUtils.getSettings()?.whatsAppNumber}");
          },
        ),
        PopupMenuItem(
          child: CustomText("Instagram"),
          onTap: () {
            $appUtils.openUrl($appUtils.getSettings()?.instagram ?? "");
          },
        ),
        PopupMenuItem(
          child: CustomText("Facebook"),
          onTap: () {
            $appUtils.openUrl($appUtils.getSettings()?.facebook ?? "");
          },
        ),
        PopupMenuItem(
          child: CustomText("Twitter"),
          onTap: () {
            $appUtils.openUrl($appUtils.getSettings()?.twitter ?? "");
          },
        ),
      ],
    );
  }

  void _showOthersPopupMenu(BuildContext context) async {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(400, 60, 10, 10),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: CustomText("Privacy & Policy"),
          onTap: () {
            navigate(SimpleTextViewer(
                title: "Privacy & Policy",
                content: $appUtils.getSettings()?.privacyPolicy ?? ""));
          },
        ),
        PopupMenuItem(
          child: CustomText("Terms & Conditions"),
          onTap: () {
            navigate(SimpleTextViewer(
                title: "Terms & Conditions",
                content: $appUtils.getSettings()?.termsAndConditions ?? ""));
          },
        ),
        PopupMenuItem(
          child: CustomText("About Us"),
          onTap: () {
            navigate(SimpleTextViewer(
                title: "About Us",
                content: $appUtils.getSettings()?.aboutUs ?? ""));
          },
        ),
      ],
    );
  }

  @override
  void observer() {
    bloc.profileStream.stream.listen((event) {
      if (event?.success == true && event?.data != null) {
        if (event?.data?.isBlocked == true) {
          navigate(const Blocked(), finishAffinity: true);
        }
      }
    });
    super.observer();
  }

  void _getSettings() {
    bloc.getSettings(
        isShowLoading: false,
        uId: user.id?.toString(),
        pId: user.pid?.toString(),
        gId: user.gid?.toString(),
        callback: (p0) {
          if (p0.success == true && p0.data != null) {
            $appUtils.saveSettings(p0.data!);
            setState(() {
              unreadNotifications = _userRole == UserRole.PHOTOGRAPHER
                  ? ($appUtils
                          .getSettings()
                          ?.unreadNotificationsPhotographer
                          ?.toInt() ??
                      0)
                  : ($appUtils
                          .getSettings()
                          ?.unreadNotificationsGuider
                          ?.toInt() ??
                      0);
            });
          }
        });
  }

  void _changeActiveStatus(bool newValue) {
    bloc.changeActiveStatus(
        newValue,
        _userRole == UserRole.GUIDER ? _photographerDto?.id?.toInt() : null,
        _userRole == UserRole.PHOTOGRAPHER
            ? _photographerDto?.id?.toInt()
            : null, (response) {
      if (response.success == true) {
        setState(() {
          _photographerDto = response.data;
        });
      } else {
        snackBar("Failed!", response.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  void _getAppointments() {
    bloc.getAppointments(getUserRole(), getDtoId()!,
        AppointmentStatus.requested, 1, "", _handleRequestedResponse);
  }

  _handleRequestedResponse(BaseListCallback<AppointmentResponse>? event) {
    if (event?.success == true) {
      try {
        requestedAppointments = event?.data ?? [];
        bloc.getAppointments(getUserRole(), getDtoId()!,
            AppointmentStatus.onGoing, 1, "", _handleOnGoingResponse);
      } catch (error) {}
    }
  }

  _handleOnGoingResponse(BaseListCallback<AppointmentResponse>? event) {
    if (event?.success == true) {
      try {
        onGoingAppointments = event?.data ?? [];
        _requestedAppointmentsPagingController
            .appendLastPage(requestedAppointments);
        _onGoingAppointmentsPagingController
            .appendLastPage(onGoingAppointments);
        setState(() {});
      } catch (error) {}
    }
  }
}
