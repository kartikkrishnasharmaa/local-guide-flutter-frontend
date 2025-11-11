import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/logo.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/enums/invoice_type.dart';
import 'package:localguider/utils/time_utils.dart';
import '../../common_libs.dart';

class InvoiceHeader extends StatelessWidget {
  TransactionDto transactionDto;
  String? name;
  String? phone;
  InvoiceType invoiceType;

  InvoiceHeader(
      {super.key,
      required this.transactionDto,
      required this.name,
        required this.phone,
      required this.invoiceType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          "Invoice",
          fontSize: 20,
          isBold: true,
        ),
        CustomText(
          transactionDto.transactionId
                  ?.replaceAll("transaction_", "")
                  .replaceAll("receipt_", "") ??
              "",
          fontSize: 14,
        ),
        gap(context, height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLogo(),
              CustomText(
                $strings.appTitle,
                isBold: true,
              ),
              CustomText("Sikar, Rajasthan, 332001"),
              CustomText("localguider07@gmail.com")
            ],
          ),
        ),
        gap(context, height: 10),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "BILL TO",
                  isBold: true,
                ),
                CustomText(name ?? ""),
                CustomText("+91${phone ?? ""}"),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    "Issue Date: ${TimeUtils.format(transactionDto.createdOn)}"),
                CustomText(
                    "Due Date: ${TimeUtils.format(transactionDto.createdOn)}"),
              ],
            ),
          ],
        ),
        gap(context, height: 10),
      ],
    );
  }
}
