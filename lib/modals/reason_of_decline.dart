import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/responsive.dart';

import '../common_libs.dart';
import '../main.dart';

class ReasonOfDecline extends StatefulWidget {

  Function(String) onDone;
  String title;
  ReasonOfDecline({required this.title, super.key, required this.onDone});

  @override
  State<ReasonOfDecline> createState() => _ReasonOfDeclineState();
}

class _ReasonOfDeclineState extends State<ReasonOfDecline> {

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(sizing(15, context)),
      width: double.maxFinite,
      child: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gap(context, height: 10),
            Row(
              children: [
                Spacer(),
                gap(context, width: 30),
                CustomText(widget.title, isBold: true,),
                Spacer(),
                IconButton(onPressed: () {
                  navigatePop(context);
                }, icon: Icon(Icons.close_rounded,)),
              ],
            ),
            gap(context, height: 10),
            InputField(hint: "Start writing here.", inputType: TextInputType.multiline, validator: (text) {
              if(text == null || text.isEmpty == true) {
                return "This field is required.";
              }
              return null;
            }, minLines: 10, maxLines: 100, maxLength: 5000, controller: _controller),
            gap(context, height: 20),
            DefaultButton("Done", onClick: () {
              if(_key.currentState!.validate()) {
                Navigator.pop(context);
                widget.onDone(_controller.text.toString());
              }
            })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
