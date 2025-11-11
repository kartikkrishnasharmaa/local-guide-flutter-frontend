import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';

class SimpleTextViewer extends StatefulWidget {
  String title;
  String content;

  SimpleTextViewer({super.key, required this.title, required this.content});

  @override
  State<SimpleTextViewer> createState() => _SimpleTextViewerState();
}

class _SimpleTextViewerState extends State<SimpleTextViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText(
          widget.title,
          fontSize: titleSize(),
          color: $styles.colors.white,
        ),
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sizing(20, context)),
        child: CustomText(
          widget.content,
          maxLines: 10000,
        ),
      ),
    );
  }
}
