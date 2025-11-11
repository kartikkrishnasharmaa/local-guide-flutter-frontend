import 'package:get/get.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/enums/invoice_type.dart';
import '../../common_libs.dart';

class InvoiceBody extends StatelessWidget {

  TransactionDto transactionDto;
  AppointmentResponse? appointmentResponse;
  InvoiceType invoiceType;

  InvoiceBody(
      {super.key, required this.transactionDto, required this.invoiceType, required this.appointmentResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(color: $styles.colors.black),
          children: [
            TableRow(
                decoration: BoxDecoration(
                  color: $styles.colors.blue,
                ),
                children: [
                  CustomText(
                    "Description",
                    isBold: true,
                    color: $styles.colors.white,
                  ).paddingAll(sizing(5, context)),
                  CustomText("Amount",
                          isBold: true, color: $styles.colors.white)
                      .paddingAll(sizing(5, context)),
                ]),
            if (invoiceType == InvoiceType.topUp) ..._topUpDetails(context),
            if (invoiceType == InvoiceType.appointment) ..._appointmentDetails(context),
          ],
        ),
        gap(context, height: 5),
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              "Payment Status: ${transactionDto.paymentStatus}",
              isBold: true,
            ))
      ],
    );
  }

  List<TableRow> _topUpDetails(BuildContext context) {
    return [
      TableRow(children: [
        CustomText(
          "Wallet Top Up",
        ).paddingAll(sizing(5, context)),
        CustomText("${transactionDto.amount?.toStringAsFixed(2) ?? "0.0"}₹")
            .paddingAll(sizing(5, context)),
      ]),
      TableRow(children: [
        CustomText(
          "Transaction Fee",
        ).paddingAll(sizing(5, context)),
        CustomText("${"0.0"}₹").paddingAll(sizing(5, context)),
      ]),
      TableRow(children: [
        CustomText(
          "Total",
          isBold: true,
        ).paddingAll(sizing(5, context)),
        CustomText("${transactionDto.amount?.toStringAsFixed(2) ?? "0.0"}₹")
            .paddingAll(sizing(5, context)),
      ]),
    ];
  }

  List<TableRow> _appointmentDetails(BuildContext context) {
    return [
      TableRow(children: [
        CustomText(
          "Appointment for ${appointmentResponse?.serviceName}",
        ).paddingAll(sizing(5, context)),
        CustomText("${appointmentResponse?.serviceCost?.toStringAsFixed(2) ?? "0.0"}₹")
            .paddingAll(sizing(5, context)),
      ]),
      TableRow(children: [
        CustomText(
          "Appointment Charges",
        ).paddingAll(sizing(5, context)),
        CustomText("${appointmentResponse?.appointmentCharge?.toStringAsFixed(2) ?? "0.0"}₹")
            .paddingAll(sizing(5, context)),
      ]),
      TableRow(children: [
        CustomText(
          "Total",
        ).paddingAll(sizing(5, context)),
        CustomText("${appointmentResponse?.totalPayment?.toStringAsFixed(2) ?? "0.0"}₹")
            .paddingAll(sizing(5, context)),
      ]),
    ];
  }

}
