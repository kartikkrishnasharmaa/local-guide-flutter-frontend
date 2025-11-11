import 'package:get/get.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/main.dart';
import 'package:localguider/modals/appointment_overview.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/appointments/appointment_created.dart';
import 'package:localguider/ui/appointments/row_service.dart';
import 'package:localguider/utils/app_state.dart';
import 'package:localguider/utils/extensions.dart';
import 'package:localguider/utils/time_utils.dart';

import '../../common_libs.dart';
import '../../components/date_picker.dart';
import '../../models/response/service_dto.dart';
import '../../responsive.dart';
import '../../user_role.dart';

class BookAppointment extends StatefulWidget {
  PhotographerDto dto;
  UserRole userRole;

  BookAppointment({super.key, required this.dto, required this.userRole});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends BaseState<BookAppointment, HomeBloc> {
  AppState _state = AppState.FETCHING_DATA;

  List<ServiceDto> services = [];
  List<String> timeSlots = [];

  ServiceDto? selectedService;
  String? selectedTimeSlot;

  double totalAmount = 0.0;

  DateTime? dateTime;

  @override
  void init() {
    disableDialogLoading = true;
    timeSlots.add("07:00 AM");
    timeSlots.add("07:30 AM");
    timeSlots.add("08:00 AM");
    timeSlots.add("08:30 AM");
    timeSlots.add("09:00 AM");
    timeSlots.add("09:30 AM");
    timeSlots.add("10:00 AM");
    timeSlots.add("10:30 AM");
    timeSlots.add("11:00 AM");
    timeSlots.add("11:30 AM");
    timeSlots.add("12:00 PM");
    timeSlots.add("12:30 PM");
    timeSlots.add("01:00 PM");
    timeSlots.add("01:30 PM");
    timeSlots.add("02:00 PM");
    timeSlots.add("02:30 PM");
    timeSlots.add("03:00 PM");
    timeSlots.add("03:30 PM");
    timeSlots.add("04:00 PM");
    timeSlots.add("04:30 PM");
    timeSlots.add("05:00 PM");
    timeSlots.add("05:30 PM");
    timeSlots.add("06:00 PM");
    timeSlots.add("06:30 PM");
    timeSlots.add("07:00 PM");
    timeSlots.add("07:30 PM");
    timeSlots.add("08:00 PM");
    timeSlots.add("08:30 PM");
    timeSlots.add("09:00 PM");
    timeSlots.add("09:30 PM");
    timeSlots.add("10:00 PM");
    timeSlots.add("10:30 PM");
  }

  @override
  void postFrame() {
    super.postFrame();
    bloc.getServices(
        widget.userRole == UserRole.PHOTOGRAPHER
            ? widget.dto.id.toString()
            : null,
        widget.userRole == UserRole.GUIDER ? widget.dto.id.toString() : null, null);
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    totalAmount = selectedService?.servicePrice?.toDouble() ?? 0.0;
    return Scaffold(
      backgroundColor: $styles.colors.secondarySurface,
      appBar: AppBar(
        backgroundColor: $styles.colors.secondarySurface,
        leading: Center(
          child: IconButton(
            onPressed: () => navigatePop(context),
            icon: Container(
              width: sizing(40, context),
              height: sizing(40, context),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular($appUtils.defaultCornerRadius),
                  color: $styles.colors.white),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: $styles.colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizing(15, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Book Appointment At",
                style: FontStyles.regular,
              ),
              gap(context, height: 10),
              CustomText(
                widget.dto.firmName ?? "",
                isBold: true,
                fontSize: sizing(18, context),
              ),
              gap(context, height: 15),
              CustomText(
                "Select Service",
                style: FontStyles.light,
              ),
              gap(context, height: 10),
              _servicesList(),
              if(selectedService != null) gap(context, height: 10),
              if(selectedService != null) Container(
                decoration: BoxDecoration(
                  color: $styles.colors.yellow.withAlpha(90),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        selectedService?.title ?? ""
                      ),
                      gap(context, height: 2),
                      CustomText(
                        "Price: ${selectedService?.servicePrice?.toStringAsFixed(2)}", isBold: true, color: $styles.colors.blue,
                      ),
                      if(selectedService?.description.isNullOrEmpty() != true) gap(context, height: 2),
                      if(selectedService?.description.isNullOrEmpty() != true) CustomText(
                        selectedService?.description ?? "", color: $styles.colors.greyStrong2,
                      )
                    ],
                  ),
                ),
              ),
              gap(context, height: 20),
              CustomInkWell(
                child: Row(
                  children: [
                    CustomText(
                      "Date: ",
                      style: FontStyles.regular,
                      isBold: true,
                    ),
                    gap(context, width: 5),
                    CustomText(
                      dateTime != null
                          ? TimeUtils.format(dateTime,
                              format: TimeUtils.dd_MM_yyyy_SLASHED)
                          : "Choose Date",
                      style: FontStyles.regular,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_month_rounded,
                      color: $styles.colors.black,
                    )
                  ],
                ),
                onTap: () {
                  appDatePicker(context: context, initialDateTime: dateTime,  firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), title: "Select Date", onPick:  (date) {
                    setState(() {
                      if (date != null) {
                        onDateSelected(date);
                      }
                    });
                  });
                },
              ),
              gap(context, height: 20),
              CustomText(
                "Choose Time",
                style: FontStyles.regular,
              ),
              gap(context, height: 15),
              _timeSlotsList(),
              gap(context, height: 20),
              CustomText("Total: ₹ ${totalAmount.toStringAsFixed(2)}"),
              gap(context, height: 25),
              DefaultButton("Pay & Proceed",
                  padding: 8,
                  iconStart: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: $styles.colors.white,
                  ), onClick: () {
                if (_validate()) {
                  Get.dialog(
                      barrierDismissible: false,
                      Dialog(
                          backgroundColor: $styles.colors.white,
                          child: AppointmentOverview(
                            userRole: widget.userRole,
                            dto: widget.dto,
                            service: selectedService!,
                            date: dateTime!,
                            time: selectedTimeSlot!,
                            onConfirm: (request) {
                              disableDialogLoading = false;
                              $logger.log(message: "message>>>>>>>>>>>>>>>   ${request.toJson()}");
                              bloc.createAppointment(request);
                            },
                            onBalanceUpdate: () {
                              disableDialogLoading = false;
                              bloc.getProfile(user.id.toString());
                            },
                          )));
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  void onDateSelected(DateTime newDate) {
    $logger.log(message: "message>>>>>>>>>>>>>>>>>>. $newDate");
    if(selectedTimeSlot == null) {
      dateTime = newDate;
      return;
    }
    String date = TimeUtils.format(newDate, format: TimeUtils.yyyyMMdd);
    String mDateTime = "$date $selectedTimeSlot";
    $logger.log(message: "message>>>>>>>>>>>>>>>>>>. $mDateTime");
    dateTime = TimeUtils.parse(mDateTime, format: TimeUtils.yyyyMMddhhMMa);
    $logger.log(message: "message>>>>>>>>>>>>>>>>>>. $dateTime");
  }

  Widget _servicesList() {
    return _state == AppState.FETCHING_DATA
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(sizing(20, context)),
              child: CircularProgressIndicator(
                color: $styles.colors.blue,
              ),
            ),
          )
        : services.isNullOrEmpty()
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(sizing(20, context)),
                  child: CustomText("No Services"),
                ),
              )
            : SizedBox(
                height: 120,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RowService(
                        service: services[index],
                        isSelected: services[index].id == selectedService?.id,
                        onClick: () {
                          setState(() {
                            selectedService = services[index];
                          });
                        },
                      );
                    },
                    itemCount: services.length,
                  ),
                ),
              );
  }

  Widget _timeSlotsList() {
    return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 2.9,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          ...timeSlots.map((e) => CustomInkWell(
                onTap: () {
                  setState(() {
                    selectedTimeSlot = e;
                    if(dateTime != null) {
                      onDateSelected(dateTime!);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(sizing(7, context)),
                  height: sizing(20, context),
                  decoration: BoxDecoration(
                      color: selectedTimeSlot == e
                          ? $styles.colors.blue
                          : $styles.colors.white,
                      borderRadius: BorderRadius.circular(sizing(10, context))),
                  child: Center(
                      child: CustomText(
                    e,
                    color: selectedTimeSlot == e
                        ? $styles.colors.white
                        : $styles.colors.black,
                  )),
                ),
              ))
        ]);
  }

  bool _validate() {
    if (selectedService == null) {
      snackBar("Service not selected", "Please select a service");
      return false;
    } else if (dateTime == null) {
      snackBar("Date not selected", "Please select a date");
      return false;
    } else if (selectedTimeSlot == null) {
      snackBar("Time not selected", "Please select a time");
      return false;
    } else if(dateTime?.isBefore(DateTime.now()) == true) {
      snackBar("Invalid date", "Please select a future date");
      return false;
    }
    return true;
  }

  @override
  void observer() {
    super.observer();

    bloc.createAppointmentStream.stream.listen((event) {
      disableDialogLoading = true;
      if(event?.success == true) {
        navigatePop(context);
        navigate(const AppointmentCreated());
      } else {
        snackBar("Failed", event?.message ?? "Something went wrong");
      }
    });

    bloc.profileStream.stream.listen((event) {
      if (event?.success == true && event?.data != null) {
        $user.saveDetails(event!.data!);
      }
      disableDialogLoading = true;
    });

    bloc.servicesListStream.stream.listen((event) {
      setState(() {
        if (event?.success == true) {
          services = event?.data ?? [];
          _state = AppState.DATA_READY;
        } else {
          _state = AppState.DATA_NOT_FETCHED;
        }
      });
    });
  }
}
