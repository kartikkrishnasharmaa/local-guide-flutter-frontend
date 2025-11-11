import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/utils/extensions.dart';

import '../../../common_libs.dart';

class RowUser extends StatelessWidget {

  UserData userData;
  Function() onClick;
  Function(UserData) onDelete;
  RowUser({super.key, required this.userData, required this.onClick, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Row(
          children: [
            ProfileView(
                diameter: 50, profileUrl: userData.profile.appendRootUrl()),
            gap(context, width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  userData.name ?? "Unknown",
                  isBold: true,
                  fontSize: 17,
                ),
                gap(context, height: 5),
                CustomText(
                  userData.username ?? "",
                  color: $styles.colors.greyMedium,
                  fontSize: 15,
                ),
              ],
            ),
            const Spacer(),
            if(userData.isBlocked == true)  gap(context, width: 10),
            if(userData.isBlocked == true) Icon(Icons.block_outlined, color: $styles.colors.red,),
            gap(context, width: 10),
            IconButton(onPressed: () {
              onDelete(userData);
            }, icon: Icon(Icons.delete_rounded, color: $styles.colors.red,)),
          ],
        ),
      ),
    );
  }
}
