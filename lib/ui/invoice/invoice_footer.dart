import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/style/styles.dart';
import '../../common_libs.dart';

class InvoiceFooter extends StatelessWidget {
  const InvoiceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        divider(),
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              "*This invoice is system generated",
              style: FontStyles.light,
              isItalic: true,
              fontSize: 12,
            ))
      ],
    );
  }
}
