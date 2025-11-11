import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/responsive.dart';

import '../common_libs.dart';
import '../main.dart';

class ReasonOfBlock extends StatefulWidget {

  Function(String) onDone;
  ReasonOfBlock({super.key, required this.onDone});

  @override
  State<ReasonOfBlock> createState() => _ReasonOfBlockState();
}

class _ReasonOfBlockState extends State<ReasonOfBlock> {

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText("Reason of block", color: Colors.white),
        leading: IconButton(onPressed: () {
          navigatePop(context);
        }, icon: Icon(Icons.close_rounded, color: $styles.colors.white,)),
      ),
      body: Container(
        padding: EdgeInsets.all(sizing(15, context)),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(hint: "Reason of block.", inputType: TextInputType.multiline, validator: (text) {
                if(text == null || text.isEmpty == true) {
                  return "Please enter reason";
                }
                return null;
              }, minLines: 10, maxLines: 100, maxLength: 5000, controller: _controller),
              const Spacer(),
              DefaultButton("Done", onClick: () {
                if(_key.currentState!.validate()) {
                  widget.onDone(_controller.text.toString());
                  navigatePop(context);
                }
              })
            ],
          ),
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
