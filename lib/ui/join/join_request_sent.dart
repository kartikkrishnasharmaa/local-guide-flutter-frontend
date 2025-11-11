import 'package:localguider/main.dart';
import 'package:localguider/ui/join/join_request_status.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../responsive.dart';
import '../../style/styles.dart';

class JoinRequestSent extends StatefulWidget {
  const JoinRequestSent({super.key});

  @override
  State<JoinRequestSent> createState() => _JoinRequestSentState();
}

class _JoinRequestSentState extends State<JoinRequestSent> {

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
              Icon(
                Icons.check_circle_rounded,
                color: $styles.colors.green,
                size: sizing(100, context),
              ),
              gap(context, height: 15),
              CustomText(
                "Request Sent Successfully.",
                style: FontStyles.regular,
                fontSize: sizing(22, context),
              ),
              gap(context, height: 25),
              CustomText(
                "We will get back to you shortly.",
                style: FontStyles.regular,
                fontSize: sizing(22, context),
              ),
              gap(context, height: 25),
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
