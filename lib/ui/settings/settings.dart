import 'package:flutter/cupertino.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/divider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool notifications = true;

  void onChanged(bool? value) {
    setState(() {
      notifications = value!;
      $appUtils.setNotificationOn(notifications);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: CustomText(
          "Settings",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizing(15, context)),
        child: Column(
          children: [
            Row(
              children: [
                CustomText(
                  "Notifications",
                  color: $styles.colors.black,
                  fontSize: sizing(17, context),
                ),
                const Spacer(),
                CupertinoSwitch(value: notifications, onChanged: onChanged)
              ],
            ),
            gap(context, height: 15),
            CustomInkWell(
              onTap: () {
                openAppSettings();
              },
              child: Row(
                children: [
                  CustomText(
                    "Permissions",
                    fontSize: sizing(17, context),
                    color: $styles.colors.black,
                  ),
                  const Spacer(),
                  Icon(Icons.settings, color: $styles.colors.black,)
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

}
