import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/ui/dashboard/row_item_appointment_request.dart';
import 'package:localguider/utils/extensions.dart';
import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../modals/reason_of_decline.dart';
import '../../models/response/appointment_response.dart';
import '../../responsive.dart';
import '../../user_role.dart';
import 'appointment_details.dart';

class AppointmentRequestsMainPage extends StatefulWidget {
  final UserRole? role;
  final String? dtoId;
  final String? initialStatus;
  final Function? refreshCallback;
  final PhotographerDto? dto;

  const AppointmentRequestsMainPage(
      {super.key,
      this.role,
      this.dtoId,
      this.dto,
      required this.initialStatus,
      this.refreshCallback});

  @override
  State<AppointmentRequestsMainPage> createState() =>
      _AppointmentRequestsMainPageState();
}

class _AppointmentRequestsMainPageState
    extends BaseState<AppointmentRequestsMainPage, HomeBloc> {
  final TextEditingController _searchController = TextEditingController();

  String get _searchText => _searchController.text;
  final int _pageSize = 10;
  int _page = 1;

  int initialTab = 0;

  String _status = AppointmentStatus.requested;

  late PagingController<int, AppointmentResponse> _pagingController;

  @override
  void init() {
    if (widget.initialStatus != null) {
      _status = widget.initialStatus!;
      initialTab = AppointmentStatus.list().indexOf(_status);
    }
    _pagingController = PagingController(firstPageKey: 1);
    disableDialogLoading = true;
    _pagingController.addPageRequestListener((pageKey) {
      if (getDtoId() == null && widget.dtoId == null) return;
      _page = pageKey;
      bloc.getAppointments(
          widget.role ?? getUserRole(),
          widget.dtoId ?? getDtoId()!,
          _status,
          pageKey,
          _searchText,
          _handleResponse);
    });
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  void postFrame() {
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _pagingController.refresh();
      }
    });
    super.postFrame();
  }

  @override
  Widget view() {
    return DefaultTabController(
      initialIndex: initialTab,
      length: AppointmentStatus.list().length,
      child: DefaultTabControllerListener(
        onTabChanged: (newTab) {
          _status = AppointmentStatus.list()[newTab];
          _pagingController.refresh();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            backgroundColor: $styles.colors.blue,
            leadingWidth: 0,
            bottom: TabBar(
              labelColor: $styles.colors.white,
              isScrollable: true,
              unselectedLabelColor: $styles.colors.greyLight,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                ...AppointmentStatus.list().map((e) => Tab(
                      text: e.mkFirstLetterUpperCase().replaceAll("_", " "),
                    ))
              ],
            ),
            title: InputField(
                bgColor: $styles.colors.white,
                focusStrokeColor: $styles.colors.white,
                enabledStrokeColor: $styles.colors.white,
                iconStart: CustomInkWell(
                    onTap: () {
                      navigatePop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: $styles.colors.black)),
                disableLabel: true,
                hint: "Search Appointments",
                controller: _searchController),
          ),
          body: _pagingView(),
        ),
      ),
    );
  }

  Widget _pagingView() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, AppointmentResponse>(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<AppointmentResponse>(
            itemBuilder: (context, item, index) => RowItemAppointmentRequest(
                  appointmentResponse: item,
                  dto: widget.dto,
                  userRole: widget.role ?? getUserRole(),
                  onResponse: (accept, decline) {
                    _onStatusChange(accept, decline, item);
                  },
                  onClick: () {
                    navigate(
                      AppointmentDetails(
                          appointment: item,
                          dto: widget.dto,
                          refreshCallback: widget.refreshCallback,
                          showActionsBtn: widget.role != UserRole.JUST_USER),
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
      ),
    );
  }

  _handleResponse(BaseListCallback<AppointmentResponse>? event) {
    if (event?.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          _page++;
          _pagingController.appendPage(newItems, _page);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    } else {
      _pagingController.error = event?.message;
    }
  }

  _onStatusChange(accept, decline, AppointmentResponse appointment) {
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
          if (widget.refreshCallback != null) {
            widget.refreshCallback!();
          }
          snackBar(
              accept ? "Accepted!" : "Cancelled!", "Request status updated");
          _pagingController.refresh();
        } else {
          snackBar("Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
        }
      },
    );
  }
}

class DefaultTabControllerListener extends StatefulWidget {
  const DefaultTabControllerListener(
      {required this.onTabChanged, required this.child, super.key});

  final ValueChanged<int> onTabChanged;

  final Widget child;

  @override
  State<DefaultTabControllerListener> createState() =>
      _DefaultTabControllerListenerState();
}

class _DefaultTabControllerListenerState
    extends State<DefaultTabControllerListener> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final TabController? defaultTabController =
        DefaultTabController.maybeOf(context);

    assert(() {
      if (defaultTabController == null) {
        throw FlutterError(
          'No DefaultTabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.',
        );
      }
      return true;
    }());

    if (defaultTabController != _controller) {
      _controller?.removeListener(_listener);
      _controller = defaultTabController;
      _controller?.addListener(_listener);
    }
  }

  void _listener() {
    final TabController? controller = _controller;

    if (controller == null || controller.indexIsChanging) {
      return;
    }

    widget.onTabChanged(controller.index);
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
