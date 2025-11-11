import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';

import '../../common_libs.dart';

class AppointmentCreated extends StatelessWidget {

  const AppointmentCreated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: $styles.colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(sizing(20, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: $styles.colors.green, size: sizing(100, context),),
              gap(context, height:  15),
              CustomText("Appointment Created Successfully.", style: FontStyles.regular, fontSize: sizing(22, context),),
              gap(context, height:  25),
              DefaultButton("Done", onClick: () {
                navigatePop(context);
              })
            ],
          ),
        ),
      ),
    );
  }
}
