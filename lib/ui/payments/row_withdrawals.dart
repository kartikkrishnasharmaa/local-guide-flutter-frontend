import 'package:localguider/components/custom_text.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/models/response/withdrawal_model.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/utils/time_utils.dart';

import '../../common_libs.dart';
import '../../main.dart';

class RowWithdrawals extends StatefulWidget {
  WithdrawalModel withdrawalDto;
  Function(WithdrawalModel model) onClick;
  RowWithdrawals({super.key, required this.withdrawalDto, required this.onClick});

  @override
  State<RowWithdrawals> createState() => _RowWithdrawalsState();
}

class _RowWithdrawalsState extends State<RowWithdrawals> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick(widget.withdrawalDto);
      },
      child: Container(
        padding: EdgeInsets.all(sizing(10, context)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sizing(20, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizing(50, context)),
                color: $styles.colors.blue.withOpacity(.3),
              ),
              child: Icon(Icons.compare_arrows_rounded, color: $styles.colors.blue),
            ),
            gap(context, width: 10),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      (widget.withdrawalDto.amount ?? 0).toStringAsFixed(2), isBold: true, fontSize: sizing(16, context), color: $styles.colors.blue,),
                  CustomText(TimeUtils.format(widget.withdrawalDto.createdOn!,
                      format: TimeUtils.MMM_dd_yyyy_hh_mm_a)),
                  CustomText(widget.withdrawalDto.paymentStatus ?? "", color: $getWithdrawalStatusColor(
                      widget.withdrawalDto.paymentStatus),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
