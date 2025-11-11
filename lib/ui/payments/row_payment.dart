import 'package:localguider/components/custom_text.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/invoice/invoice.dart';
import 'package:localguider/utils/time_utils.dart';
import '../../common_libs.dart';
import '../../main.dart';

class RowPayment extends StatefulWidget {
  TransactionDto transactionDto;
  bool isAdmin = false;
  String customerName;
  String customerPhone;

  RowPayment(
      {super.key, required this.transactionDto, required this.isAdmin, required this.customerName, required this.customerPhone});

  @override
  State<RowPayment> createState() => _RowPaymentState();
}

class _RowPaymentState extends State<RowPayment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizing(10, context)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sizing(20, context)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sizing(50, context)),
              color: widget.isAdmin
                  ? $styles.colors.blue.withOpacity(.3)
                  : widget.transactionDto.isCredit == true
                  ? $styles.colors.green.withOpacity(.3)
                  : $styles.colors.red.withOpacity(.3),
            ),
            child: widget.isAdmin
                ? Icon(Icons.payment_rounded, color: $styles.colors.blue)
                : widget.transactionDto.isCredit == true
                ? Icon(Icons.add, color: $styles.colors.green)
                : Icon(Icons.remove, color: $styles.colors.red),
          ),
          gap(context, width: 10),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  (widget.transactionDto.amount ?? 0).toStringAsFixed(2),
                  isBold: true,
                  fontSize: sizing(16, context),
                  color: $styles.colors.blue,
                ),
                CustomText(TimeUtils.format(widget.transactionDto.createdOn!,
                    format: TimeUtils.MMM_dd_yyyy_hh_mm_a)),
                if(!widget.isAdmin) CustomText(
                  widget.transactionDto.paymentStatus ?? "",
                  color: $getPaymentStatusColor(
                      widget.transactionDto.paymentStatus),
                ),
                if(widget.isAdmin) Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "By: ${widget.transactionDto.other ?? ""}",
                      color: $styles.colors.black,
                    ),
                    gap(context, width: 20),
                    CustomText(
                      widget.transactionDto.paymentStatus ?? "",
                      color: $getPaymentStatusColor(
                          widget.transactionDto.paymentStatus),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          if(!widget.isAdmin) IconButton(onPressed: () {
            navigate(Invoice(
              transactionDto: widget.transactionDto,
              customerName: widget.customerName,
              customerPhone: widget.customerPhone,
            ));
          }, icon: Icon(Icons.download_for_offline_outlined))
        ],
      ),
    );
  }
}
