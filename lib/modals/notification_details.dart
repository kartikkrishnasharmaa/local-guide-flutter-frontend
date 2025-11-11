import 'dart:convert';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/models/response/notification_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/ui/photographers/photographer_details.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/time_utils.dart';
import '../common_libs.dart';
import '../components/custom_text.dart';
import '../main.dart';
import '../responsive.dart';

class NotificationDetails extends StatefulWidget {
  NotificationModel notificationModel;
  Function() refreshCallback;

  NotificationDetails({super.key,
    required this.notificationModel,
    required this.refreshCallback});

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState
    extends BaseState<NotificationDetails, HomeBloc> {

  PhotographerDto? photographerDto;

  @override
  void init() {
    if (widget.notificationModel.markAsRead != true) {
      bloc.markAsReadNotification(widget.notificationModel.id.toString(), (p0) {
        widget.refreshCallback();
      });
    }
    final note = widget.notificationModel.note;
    print("object -------> $note");
    if (note != null && note.isNotEmpty) {
      final Map<String, dynamic> jsonMap = jsonDecode(note);
      photographerDto = PhotographerDto.fromJson(jsonMap);
    }
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: $styles.colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(sizing(10, context)),
            topLeft: Radius.circular(sizing(10, context))),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
        left: sizing(10, context),
        right: sizing(10, context),
        top: sizing(10, context),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizing(5, context),
            ),
            Center(
              child: Container(
                width: sizing(35, context),
                height: sizing(5, context),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(sizing(10, context)),
                ),
              ),
            ),
            SizedBox(
              height: sizing(15, context),
            ),
            Center(
              child: CustomText(
                widget.notificationModel.title ?? "",
                color: $styles.colors.title,
              ),
            ),
            gap(context, height: 10),
            CustomText(
              TimeUtils.format(
                  TimeUtils.parseUtcToLocal(widget.notificationModel.createdOn),
                  format: TimeUtils.MMM_dd_yyyy_hh_mm_a),
              color: $styles.colors.greyMedium,
              fontSize: 12,
            ),
            gap(context, height: 10),
            CustomText(
              widget.notificationModel.description ?? "",
              maxLines: 100,
            ),
            gap(context, height: 20),
            if (widget.notificationModel.title
                ?.toLowerCase()
                .contains("leave a review") ==
                true)
              DefaultButton("Go To Profile", onClick: () {
                navigatePop(context);
                navigate(PhotographerDetails(dto: photographerDto!,
                    userRole: widget.notificationModel.guiderId != null ? UserRole.GUIDER : UserRole.PHOTOGRAPHER,
                    refreshCallback: () {}));
              })
          ],
        ),
      ),
    );
  }
}
