import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_callback.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/modals/notification_details.dart';
import 'package:localguider/ui/admin/notificaion/send_notification.dart';
import 'package:localguider/ui/settings/row_notification.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/response/notification_model.dart';
import '../../responsive.dart';
import '../../user_role.dart';

class Notifications extends StatefulWidget {

  UserRole userRole;
  String dtoId;
  Function() refreshCallback;
  Notifications({super.key, required this.userRole, required this.dtoId, required this.refreshCallback});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends BaseState<Notifications, HomeBloc> {

  final int _pageSize = 10;
  int _page = 1;

  final PagingController<int, NotificationModel> _notificationsController =
      PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;
    _notificationsController.addPageRequestListener((pageKey) {
      _page = pageKey;
      bloc.getNotifications(widget.userRole, widget.dtoId, pageKey, (p0) {
        _handleResponse(p0);
      });
    });
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        centerTitle: true,
        actions: [
          if(widget.userRole == UserRole.ADMIN) Padding(
            padding: EdgeInsets.only(right: sizing(10, context)),
            child: IconButton(onPressed: () {
              navigate(SendNotification(
                refreshCallback: () {
                  _notificationsController.refresh();
                },
              ));
            }, icon: Icon(Icons.add, color: $styles.colors.white,)),
          )
        ],
        title: CustomText(
          "Notifications",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _notificationsController.refresh(),
        ),
        child: PagedListView<int, NotificationModel>(
          shrinkWrap: true,
          pagingController: _notificationsController,
          builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
              itemBuilder: (context, item, index) =>
                  RowNotification(notificationModel: item, onDismissed: (model) {
                    _deleteNotification(model);
                  }, onClick: (NotificationModel model) {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 1,
                            child: NotificationDetails(
                              notificationModel: model,
                              refreshCallback: () {
                                widget.refreshCallback();
                              },
                            ),
                          );
                        });
                  },),
              firstPageProgressIndicatorBuilder: (context) => Center(
                      child: Padding(
                    padding: EdgeInsets.all(sizing(30, context)),
                    child: CircularProgressIndicator(
                      color: $styles.colors.blue,
                    ),
                  )),
              noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Padding(
                    padding: EdgeInsets.all(sizing(30, context)),
                    child: CustomText("No Result Found"),
                  )),
              firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Padding(
                    padding: EdgeInsets.all(sizing(30, context)),
                    child: CustomText("No Result Found"),
                  ))),
        ),
      ),
    );
  }

  _deleteNotification(NotificationModel model) {
    bloc.deleteNotification(model.id.toString(),  (p0) { });
  }

  _handleResponse(BaseListCallback<NotificationModel>? event) {
    if (event?.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        if (isLastPage) {
          _notificationsController.appendLastPage(newItems);
        } else {
          _page++;
          _notificationsController.appendPage(newItems, _page);
        }
      } catch (error) {
        _notificationsController.error = error;
      }
    } else {
      _notificationsController.error = event?.message;
    }
  }
}
