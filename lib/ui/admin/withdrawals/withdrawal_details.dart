import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/models/response/withdrawal_model.dart';
import 'package:localguider/ui/enums/withdrawal_status.dart';

import '../../../common_libs.dart';
import '../../../components/custom_text.dart';
import '../../../components/default_button.dart';
import '../../../main.dart';
import '../../../models/response/appointment_response.dart';
import '../../../responsive.dart';
import '../../../style/styles.dart';

class WithdrawalDetails extends StatefulWidget {
  WithdrawalModel withdrawalModel;
  Function refreshCallback;

  WithdrawalDetails(
      {super.key,
      required this.withdrawalModel,
      required this.refreshCallback});

  @override
  State<WithdrawalDetails> createState() => _WithdrawalDetailsState();
}

class _WithdrawalDetailsState extends BaseState<WithdrawalDetails, HomeBloc> {
  double hintSize = 12;
  double valueSize = 15;
  double itemGaps = 20;
  double hintValueGap = 10;

  @override
  void init() {}

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText(
          "Withdrawal Details",
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText("Status: ",
                    color: $styles.colors.black, fontSize: sizing(20, context)),
                const Spacer(),
                CustomText(widget.withdrawalModel.paymentStatus ?? "",
                    color: $getWithdrawalStatusColor(
                        widget.withdrawalModel.paymentStatus),
                    style: FontStyles.openSansMedium,
                    fontSize: sizing(20, context)),
              ],
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Total Amount",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${widget.withdrawalModel.amount?.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
              fontSize: sizing(valueSize, context),
            ),
            CustomText(
              "Charges",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomText(
              "${widget.withdrawalModel.charge?.toStringAsFixed(2)} ₹",
              style: FontStyles.regular,
              fontSize: sizing(valueSize, context),
            ),
            CustomText(
              widget.withdrawalModel.paymentStatus ==
                      WithdrawalStatus.success.value
                  ? "Amount Settled"
                  : "Amount To Be Settled",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(widget.withdrawalModel.amountToBeSettled
                    ?.toStringAsFixed(2)
                    .toString());
              },
              child: CustomText(
                "${widget.withdrawalModel.amountToBeSettled?.toStringAsFixed(2)} ₹",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Bank Name",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(
                  widget.withdrawalModel.useUpi == true
                      ? "NA"
                      : widget.withdrawalModel.bankName ?? "NA",
                );
              },
              child: CustomText(
                widget.withdrawalModel.useUpi == true
                    ? "NA"
                    : widget.withdrawalModel.bankName ?? "NA",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Account Number",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(
                  widget.withdrawalModel.useUpi == true
                      ? "NA"
                      : widget.withdrawalModel.accountNumber ?? "NA",
                );
              },
              child: CustomText(
                widget.withdrawalModel.useUpi == true
                    ? "NA"
                    : widget.withdrawalModel.accountNumber ?? "NA",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "Account Holder Name",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(
                  widget.withdrawalModel.useUpi == true
                      ? "NA"
                      : widget.withdrawalModel.accountHolderName ?? "NA",
                );
              },
              child: CustomText(
                widget.withdrawalModel.useUpi == true
                    ? "NA"
                    : widget.withdrawalModel.accountHolderName ?? "NA",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "IFSC",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(
                  widget.withdrawalModel.useUpi == true
                      ? "NA"
                      : widget.withdrawalModel.ifsc ?? "NA",
                );
              },
              child: CustomText(
                widget.withdrawalModel.useUpi == true
                    ? "NA"
                    : widget.withdrawalModel.ifsc ?? "NA",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            CustomText(
              "UPI ID",
              style: FontStyles.light,
              fontSize: hintSize,
            ),
            gap(context, height: hintValueGap),
            CustomInkWell(
              onTap: () {
                _copyText(
                  widget.withdrawalModel.useUpi != true
                      ? "NA"
                      : widget.withdrawalModel.upiId ?? "NA",
                );
              },
              child: CustomText(
                widget.withdrawalModel.useUpi != true
                    ? "NA"
                    : widget.withdrawalModel.upiId ?? "NA",
                style: FontStyles.regular,
                fontSize: sizing(valueSize, context),
              ),
            ),
            gap(context, height: itemGaps),
            if (widget.withdrawalModel.paymentStatus ==
                    WithdrawalStatus.inProgress.value &&
                $isAdmin)
              Row(
                children: [
                  Expanded(
                    child: DefaultButton("Accept", onClick: () {
                      _onStatusChange(true, false);
                    }),
                  ),
                  gap(context, width: 10),
                  Expanded(
                    child: DefaultButton("Cancel", bgColor: $styles.colors.red,
                        onClick: () {
                      _onStatusChange(false, true);
                    }),
                  ),
                ],
              ),
            gap(context, height: itemGaps),
          ],
        ),
      ),
    );
  }

  _onStatusChange(success, cancel) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: success ? "Withdrawal Success?" : "Cancel Withdrawal?",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc: success
                ? "Are you sure you made payment on the given details."
                : "Payment will be deposited into the vendor's wallet after cancellation.\nAre you sure you want to decline this withdrawal.",
            btnCancelText: "No",
            btnOkText: "Yes",
            btnOkOnPress: () {
              bloc.respondWithdrawal(
                widget.withdrawalModel.id.toString(),
                success
                    ? WithdrawalStatus.success.value
                    : WithdrawalStatus.canceled.value,
                "",
                (p0) {
                  if (p0.success == true) {
                    widget.refreshCallback();
                    snackBar(success ? "Success!" : "Cancelled!",
                        "Withdrawal status updated");
                    setState(() {
                      widget.withdrawalModel = p0.data!;
                    });
                  } else {
                    snackBar(
                        "Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
                  }
                },
              );
            },
            btnCancelOnPress: () {})
        .show();
  }

  _copyText(text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
