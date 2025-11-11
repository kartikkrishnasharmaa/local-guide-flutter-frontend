import 'package:localguider/components/custom_text.dart';
import 'package:localguider/models/requests/create_appointment_dto.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/service_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/payments/add_payment.dart';
import 'package:localguider/user_role.dart';

import '../common_libs.dart';
import '../components/default_button.dart';
import '../main.dart';
import '../utils/time_utils.dart';

class AppointmentOverview extends StatefulWidget {
  PhotographerDto dto;
  ServiceDto service;
  DateTime date;
  String time;
  UserRole userRole;
  Function(CreateAppointmentDto) onConfirm;
  Function() onBalanceUpdate;

  AppointmentOverview(
      {super.key,
        required this.userRole,
      required this.dto,
      required this.service,
      required this.date,
      required this.time,
      required this.onConfirm, required this.onBalanceUpdate});

  @override
  State<AppointmentOverview> createState() => _AppointmentOverviewState();
}

class _AppointmentOverviewState extends State<AppointmentOverview> {

  double total = 0.0;
  double appointmentCharge = 0.0;
  double serviceCharge = 0.0;
  double appointmentChargePercentage = 5;
  double availableBalance = 0.0;

  @override
  void initState() {
    super.initState();
    serviceCharge = widget.service.servicePrice?.toDouble() ?? 0.0;
    _calculateCharge();
    total = serviceCharge + appointmentCharge;
    availableBalance = $user.getUser()?.balance?.toDouble() ?? 0.0;
  }

  _calculateCharge() {
    appointmentCharge = $appUtils.getSettings()?.appointmentPlatformCharge != null ? ((serviceCharge * ($appUtils.getSettings()!.appointmentPlatformCharge!)) / 100) : 0.0;
  }

  double hintSize = 10;
  double valueSize = 13;
  double itemGaps = 10;
  double hintValueGap = 8;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(sizing(15, context)),
        decoration: BoxDecoration(
          color: $styles.colors.white,
          borderRadius: BorderRadius.circular(sizing(5, context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  navigatePop(context);
                },
                child: Container(
                  height: sizing(30, context),
                  width: sizing(50, context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizing(15, context)),
                      color: $styles.colors.greyLight),
                  child: Icon(Icons.close_rounded, color: $styles.colors.black),
                ),
              ),
            ),
            CustomText(
              "Appointment At",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              widget.dto.firmName ?? "",
              isBold: true,
              fontSize: sizing(valueSize, context),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Selected Service",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            Container(
              padding: EdgeInsets.all(sizing(5, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizing(5, context)),
                color: $styles.colors.green.withOpacity(.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    widget.service.title ?? "",
                    style: FontStyles.regular,
                    isBold: true,
                    fontSize: sizing(hintSize, context),
                  ),
                  CustomText(
                    "${widget.service.servicePrice?.toStringAsFixed(2) ?? "0.0"} ₹",
                    style: FontStyles.regular,
                    color: $styles.colors.green,
                    fontSize: sizing(hintSize, context),
                  ),
                ],
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Total:",
              style: FontStyles.regular,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText("${total.toStringAsFixed(2)} ₹"),
            gap(context, height: itemGaps),
            CustomText(
              "Date",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              TimeUtils.format(widget.date,
                  format: TimeUtils.dd_MM_yyyy_SLASHED),
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Time",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              widget.time,
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Your available balance",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${availableBalance.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Total Service Cost",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${serviceCharge.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Appointment Charge",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${appointmentCharge.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Total Amount to Pay",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${total.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
            ),
            gap(context, height: itemGaps),
            if (total > availableBalance)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: $styles.colors.red,
                  ),
                  gap(context, width: 10),
                  Flexible(
                      child: CustomText(
                    "Your wallet balance is low to proceed this payment please add balance in wallet",
                    color: $styles.colors.red,
                  ))
                ],
              ),
            if (total > availableBalance) gap(context, height: 10),
            if (total > availableBalance)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: sizing(sizing(110, context), context),
                  child:
                      DefaultButton("Add Balance", padding: 8, onClick: () {
                        navigate(AddPayment(userId: $user.getUser()?.id.toString(), callback: (b, addedBalance) {
                          navigatePop(context);
                          widget.onBalanceUpdate();
                        }));
                      }),
                ),
              ),
            if (total > availableBalance) gap(context, height: 20),
            gap(context, height: itemGaps),
            DefaultButton("Confirm Appointment", padding: 8, onClick: () {
              if (total > availableBalance) {
                snackBar("Insufficient Balance",
                    "Your balance is insufficient for this appointment. Please add balance in your wallet");
              } else {
                navigatePop(context);
                widget.onConfirm(
                  CreateAppointmentDto(
                    userId: $user.getUser()?.id,
                    photographerId: widget.userRole == UserRole.PHOTOGRAPHER ? widget.dto.id : null,
                    guiderId: widget.userRole == UserRole.GUIDER ? widget.dto.id : null,
                    dateTime: "${TimeUtils.format(widget.date, format: TimeUtils.yyyyMMdd)} ${widget.time}",
                    transactionId: Random.secure().nextInt(10000000).toString(),
                    serviceId: widget.service.id,
                    serviceCost: serviceCharge,
                    appointmentCharge: appointmentCharge,
                    totalPayment: total,
                    paymentStatus: "success"
                  )
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
