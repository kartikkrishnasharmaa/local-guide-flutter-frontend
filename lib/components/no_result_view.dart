import '../../common_libs.dart';
import '../responsive.dart';
import 'custom_text.dart';

class NoResult extends StatelessWidget {

  String? text;

  NoResult({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sizing(20, context)),
        child: CustomText(text ?? "No Result", fontSize: 14),
      ),
    );
  }
}
