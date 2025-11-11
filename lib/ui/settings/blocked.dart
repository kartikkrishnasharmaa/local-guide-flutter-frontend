import 'package:localguider/components/default_button.dart';
import 'package:localguider/main.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/home/home.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../responsive.dart';

class Blocked extends StatefulWidget {
  
  const Blocked({super.key});

  @override
  State<Blocked> createState() => _BlockedState();
}

class _BlockedState extends State<Blocked> {

  @override
  void initState() {
    AdminBloc().getAccountDetails($user.getUser()?.id.toString(), (response) {
      if(response.success == true) {
        if(response.data != null) {
          $user.saveDetails(response.data!);
          if(response.data?.isBlocked != true) {
            navigate(Home());
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText("Blocked", color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(sizing(15, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap(context, height: 20),
            CustomText("You are blocked", fontSize: sizing(17, context), isBold: true, color: $styles.colors.red,),
            gap(context, height: 10),
            CustomText("Reason:", color: $styles.colors.greyMedium,),
            gap(context, height: 10),
            CustomText($user.getUser()?.reasonOfBlock ?? "Blocked by Admin", color: $styles.colors.black,),
            gap(context, height: 20),
            DefaultButton("Close", bgColor: $styles.colors.red, onClick: () {
              SystemNavigator.pop(animated: true);
            })
          ],
        ),
      ),
    );
  }
}
