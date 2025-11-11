import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/input_field.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/utils/extensions.dart';

import '../../../common_libs.dart';

class SimpleTextEditor extends StatefulWidget {
  String title;
  String content;
  Function(String text) onSave;
  SimpleTextEditor({super.key, required this.title, required this.content, required this.onSave});

  @override
  State<SimpleTextEditor> createState() => _SimpleTextEditorState();
}

class _SimpleTextEditorState extends State<SimpleTextEditor> {

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(onPressed: () {
          navigatePop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded, color: $styles.colors.white,)),
        title: CustomText(
          widget.title,
          fontSize: titleSize(),
          color: $styles.colors.white,
        ),
        actions: [
          IconButton(onPressed: () {
            navigatePop(context);
            widget.onSave(_controller.text);
          }, icon: Icon(Icons.check_rounded, color: $styles.colors.white,))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(sizing(15, context)),
        child: Align(
          alignment: Alignment.topCenter,
          child: InputField(
            hint: "Start typing here...",
            disableLabel: true,
            minLines: 100,
            maxLines: 200,
            maxLength: 5000,
            inputType: TextInputType.multiline,
            controller: _controller,
            validator: (text) {
              if (text.isNullOrEmpty()) {
                return "This field is required";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
