import 'package:localguider/components/custom_text.dart';
import 'package:localguider/responsive.dart';

import '../../common_libs.dart';
import '../../models/response/notification_model.dart';

class RowNotification extends StatelessWidget {

  NotificationModel notificationModel;
  Function(NotificationModel) onDismissed;
  Function(NotificationModel) onClick;
  RowNotification({super.key, required this.notificationModel, required this.onDismissed, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notificationModel.id.toString()),
      onDismissed: (direction) {
        onDismissed(notificationModel);
      },
      child: InkWell(
        onTap: () {
          onClick(notificationModel);
        },
        child: Padding(
          padding: EdgeInsets.all(sizing(10, context)),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(sizing(15, context)),
            child: Container(
              padding: EdgeInsets.all(sizing(10, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizing(15, context))
              ),
              child: Row(
                children: [
                  gap(context, width: 10),
                  Icon(notificationModel.type == "appointment" ? Icons.calendar_month : Icons.notifications,),
                  gap(context, width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(notificationModel.title ?? "", isBold: true,),
                        CustomText(notificationModel.description ?? "", maxLines: 2,),
                      ],
                    ),
                  ),
                  gap(context, width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
