import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/modals/reason_of_decline.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/dashboard/row_item_appointment_request.dart';
import '../../common_libs.dart';
import '../../main.dart';
import '../../models/response/user_data.dart';
import '../../user_role.dart';
import 'appointment_details.dart';
import 'appointment_status.dart';

class AppointmentRequests extends StatelessWidget {
  final String? status;
  final UserRole? role;
  final String? dtoId;
  final HomeBloc bloc;
  final PhotographerDto? dto;
  PagingController<int, AppointmentResponse> pagingController;

  AppointmentRequests(
      {super.key,
      this.status,
      this.role,
      this.dtoId,
      required this.pagingController,
      required this.bloc,
      required this.dto});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, AppointmentResponse>(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<AppointmentResponse>(
          itemBuilder: (context, item, index) => RowItemAppointmentRequest(
                appointmentResponse: item,
                dto: dto,
                userRole: role ?? getUserRole(),
                onResponse: (accept, decline) {
                  _onStatusChange(context, accept, decline, item);
                },
                onClick: () {
                  navigate(
                    AppointmentDetails(
                        appointment: item,
                        dto: dto,
                        refreshCallback: () {
                          pagingController.refresh();
                        },
                        showActionsBtn: role != UserRole.JUST_USER),
                  );
                },
              ),
          noItemsFoundIndicatorBuilder: (context) => Center(
              child: Padding(
                  padding: EdgeInsets.all(sizing(20, context)),
                  child: CustomText("No Result Found"))),
          firstPageProgressIndicatorBuilder: (context) => Center(
                  child: Padding(
                padding: EdgeInsets.all(sizing(30, context)),
                child: CircularProgressIndicator(
                  color: $styles.colors.blue,
                ),
              )),
          firstPageErrorIndicatorBuilder: (context) => Center(
                  child: Padding(
                padding: EdgeInsets.all(sizing(20, context)),
                child: CustomText("No Result Found"),
              ))),
    );
  }

  UserData get user => $user.getUser() ?? UserData();

  UserRole getUserRole() {
    if (user.gid != null) {
      return UserRole.GUIDER;
    } else if (user.pid != null) {
      return UserRole.PHOTOGRAPHER;
    }
    return UserRole.JUST_USER;
  }

  String? getDtoId() {
    if (getUserRole() == UserRole.PHOTOGRAPHER) {
      return user.pid?.toString();
    } else if (getUserRole() == UserRole.GUIDER) {
      return user.gid?.toString();
    } else {
      return user.id.toString();
    }
  }

  _onStatusChange(
      BuildContext context, accept, decline, AppointmentResponse appointment) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: accept ? "Accept Appointment!" : "Cancel Appointment",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc:
                "Are you sure you want to ${accept ? "Accept" : "Decline"} this request?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              if (decline == true) {
                Get.dialog(
                    barrierDismissible: false,
                    Dialog(
                        backgroundColor: $styles.colors.white,
                        child: ReasonOfDecline(
                            title: "Reason of Cancel!",
                            onDone: (text) {
                              _respond(accept, decline, appointment, text);
                            })));
              } else {
                _respond(accept, decline, appointment, "");
              }
            },
            btnCancelOnPress: () {})
        .show();
  }

  void _respond(accept, decline, AppointmentResponse appointment, reason) {
    bloc.respondAppointment(
      appointment.id.toString(),
      accept ? AppointmentStatus.accepted : AppointmentStatus.cancelled,
      reason,
      (p0) {
        if (p0.success == true) {
          snackBar(
              accept ? "Accepted!" : "Cancelled!", "Request status updated");
          pagingController.refresh();
        } else {
          snackBar("Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
        }
      },
    );
  }
}
