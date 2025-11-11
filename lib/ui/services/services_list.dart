import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/services/add_edit_service.dart';
import 'package:localguider/ui/services/row_services_n_plans.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../models/response/photographer_dto.dart';
import '../../models/response/service_dto.dart';
import '../../user_role.dart';
import '../../utils/app_state.dart';

class ServicesList extends StatefulWidget {
  UserRole? userRole;
  PhotographerDto? dto;
  bool isSelectionOnly;
  List<ServiceDto>? selectedService;
  Function(List<ServiceDto> selectedService)? callback;

  ServicesList(
      {super.key,
      this.dto,
      this.userRole,
      this.isSelectionOnly = false,
      this.selectedService,
      this.callback});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends BaseState<ServicesList, HomeBloc> {
  List<ServiceDto> _services = [];
  AppState _state = AppState.FETCHING_DATA;

  @override
  void init() {
    disableDialogLoading = true;
  }

  @override
  void postFrame() {
    super.postFrame();
    if (!widget.isSelectionOnly) {
      bloc.getServices(
          widget.userRole == UserRole.PHOTOGRAPHER
              ? widget.dto?.id.toString()
              : null,
          widget.userRole == UserRole.GUIDER
              ? widget.dto?.id.toString()
              : null, null);
    } else {
      setState(() {
        _state = AppState.DATA_READY;
      });
    }
    if (!widget.selectedService.isNullOrEmpty()) {
      setState(() {
        _services.addAll(widget.selectedService!);
      });
    }
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              if (widget.isSelectionOnly) {
                _backConfirm();
              } else {
                navigatePop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        title: CustomText(
          "Services & Plans",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 1,
            left: 1,
            right: 1,
            bottom: 70,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(sizing(10, context)),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  gap(context, height: 10),
                  DefaultButton("Add Service", onClick: () {
                    navigate(AddEditService(
                        photographerId:
                            widget.userRole == UserRole.PHOTOGRAPHER &&
                                    !widget.isSelectionOnly
                                ? widget.dto?.id.toString()
                                : null,
                        guiderId: widget.userRole == UserRole.GUIDER &&
                                !widget.isSelectionOnly
                            ? widget.dto?.id.toString()
                            : null,
                        isSelectionOnly: widget.isSelectionOnly,
                        callback: _handleCallback));
                  }),
                  gap(context, height: 10),
                  _state == AppState.FETCHING_DATA
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(sizing(20, context)),
                            child: CircularProgressIndicator(
                              color: $styles.colors.blue,
                            ),
                          ),
                        )
                      : _services.isNullOrEmpty()
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(sizing(20, context)),
                                child: CustomText("No Services"),
                              ),
                            )
                          : Center(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return RowServicesNPlans(
                                    service: _services[index],
                                    isSelectionOnly: widget.isSelectionOnly,
                                    onResponse: (bool edit, bool delete) {
                                      if (edit) {
                                        navigate(AddEditService(
                                            photographerId: widget.userRole ==
                                                        UserRole.PHOTOGRAPHER &&
                                                    !widget.isSelectionOnly
                                                ? widget.dto?.id.toString()
                                                : null,
                                            guiderId: widget.userRole ==
                                                        UserRole.GUIDER &&
                                                    !widget.isSelectionOnly
                                                ? widget.dto?.id.toString()
                                                : null,
                                            isSelectionOnly:
                                                widget.isSelectionOnly,
                                            serviceDto: _services[index],
                                            callback: _handleCallback));
                                      } else if (delete) {
                                        _deleteService(_services[index]);
                                      }
                                    },
                                  );
                                },
                                itemCount: _services.length,
                              ),
                            ),
                ],
              ),
            ),
          ),
          if (widget.isSelectionOnly)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(sizing(15, context)),
                child: DefaultButton("Save",
                    enable: _services.isNotEmpty,
                    bgColor: _services.isNotEmpty
                        ? $styles.colors.blue
                        : $styles.colors.greyMedium, onClick: () {
                  if (widget.isSelectionOnly) {
                    widget.callback!(_services);
                    navigatePop(context);
                  }
                }),
              ),
            ),
        ],
      ),
    );
  }

  _deleteService(ServiceDto service) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: "Delete Service!",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc: "Are you sure you want to delete this service?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              if (widget.isSelectionOnly) {
                setState(() {
                  _services.remove(service);
                });
              } else {
                disableDialogLoading = false;
                bloc.deleteServices(service.id.toString(), (p0) {
                  disableDialogLoading = true;
                  if (p0.success == true) {
                    setState(() {
                      _services.remove(service);
                    });
                  }
                });
              }
            },
            btnCancelOnPress: () {})
        .show();
  }

  _backConfirm() {
    if (!_anyChanges()) {
      navigatePop(context);
      return;
    }

    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        padding: EdgeInsets.all(sizing(15, context)),
        title: "Discard Changes!",
        dialogBackgroundColor: $styles.colors.background,
        titleTextStyle: TextStyle(
          color: $styles.colors.title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        descTextStyle: TextStyle(
          color: $styles.colors.title,
        ),
        desc: "All changes will be lost?",
        btnCancelText: "Discard",
        btnOkText: "Continue",
        btnOkOnPress: () {},
        btnCancelOnPress: () {
          navigatePop(context);
        }).show();
  }

  bool _anyChanges() {
    if (widget.selectedService?.length != _services.length) {
      return true;
    }
    for (int i = 0; i < _services.length; i++) {
      if (widget.selectedService![i].title != _services[i].title ||
          widget.selectedService![i].description != _services[i].description ||
          widget.selectedService![i].servicePrice !=
              _services[i].servicePrice || widget.selectedService![i].image != _services[i].image) {
        return true;
      }
    }
    return false;
  }

  _handleCallback(bool isEdit, ServiceDto service) {
    if (isEdit) {
      setState(() {
        int index = _services.indexWhere((element) => element.id == service.id);
        _services.removeAt(index);
        _services.insert(index, service);
      });
    } else {
      setState(() {
        _services.add(service);
      });
    }
  }

  @override
  void observer() {
    super.observer();
    if (!widget.isSelectionOnly) {
      bloc.servicesListStream.stream.listen((event) {
        setState(() {
          if (event?.success == true) {
            _services = event?.data ?? [];
            _state = AppState.DATA_READY;
          } else {
            _state = AppState.DATA_NOT_FETCHED;
          }
        });
      });
    }
  }
}
