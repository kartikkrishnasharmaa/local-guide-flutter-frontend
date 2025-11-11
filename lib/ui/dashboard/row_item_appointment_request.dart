import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/dashboard/appointment_details.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/app_utils.dart';
import 'package:localguider/utils/time_utils.dart';
import '../../common_libs.dart';
import '../../style/styles.dart';

class RowItemAppointmentRequest extends StatefulWidget {

  AppointmentResponse appointmentResponse;
  UserRole userRole;
  PhotographerDto? dto;
  Function(bool approve, bool decline)? onResponse;
  Function onClick;

  RowItemAppointmentRequest({
    super.key,
    required this.appointmentResponse,
    required this.userRole,
    this.dto,
    this.onResponse,
    required this.onClick
  });

  @override
  State<RowItemAppointmentRequest> createState() =>
      _RowItemAppointmentRequestState();
}

class _RowItemAppointmentRequestState extends State<RowItemAppointmentRequest> {
  String _status = AppointmentStatus.requested;

  @override
  void initState() {
    _status = widget.appointmentResponse.appointmentStatus ??
        AppointmentStatus.requested;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       widget.onClick();
      },
      child: Padding(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    top: sizing(
                        (_status == AppointmentStatus.requested &&
                                widget.userRole != UserRole.JUST_USER)
                            ? 18
                            : 0,
                        context)),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(sizing(15, context)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizing(15, context)),
                      border: Border.all(color: $styles.colors.blue, width: 1)),
                  child: Row(
                    children: [
                      ProfileView(
                          diameter: 50, profileUrl: placeHolderImageUrl),
                      gap(context, width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gap(context, height: 5),
                          CustomText(
                            widget.appointmentResponse.customerName ?? "",
                            fontSize: sizing(16, context),
                            maxLines: 1,
                            color: $styles.colors.blue,
                            style: FontStyles.medium,
                          ),
                          CustomText(
                              "For: ${widget.appointmentResponse.serviceName ?? ""}",
                              fontSize: sizing(13, context),
                              maxLines: 1),
                          CustomText(
                              "Price: ${widget.appointmentResponse.serviceCost}",
                              color: $styles.colors.greyMedium,
                              fontSize: sizing(13, context),
                              maxLines: 1),
                          CustomText(
                              TimeUtils.format(
                                  TimeUtils.parseUtcToLocal(
                                      widget.appointmentResponse.date),
                                  format: TimeUtils.MMM_dd_yyyy_hh_mm_a),
                              fontSize: sizing(13, context),
                              maxLines: 1),
                        ],
                      )),
                      if (_status == AppointmentStatus.requested &&
                          widget.userRole != UserRole.JUST_USER)
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (widget.onResponse != null) {
                                    widget.onResponse!(true, false);
                                  }
                                },
                                icon: Icon(
                                  Icons.check_rounded,
                                  color: $styles.colors.green,
                                )),
                            IconButton(
                                onPressed: () {
                                  if (widget.onResponse != null) {
                                    widget.onResponse!(false, true);
                                  }
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: $styles.colors.red,
                                )),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            if (_status == AppointmentStatus.requested &&
                widget.userRole != UserRole.JUST_USER)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: $styles.colors.blue,
                      borderRadius: BorderRadius.circular(sizing(15, context))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "Requests",
                        color: $styles.colors.white,
                        fontSize: sizing(18, context),
                      ),
                      gap(context, width: 5),
                      Icon(
                        Icons.circle,
                        color: $styles.colors.red,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
