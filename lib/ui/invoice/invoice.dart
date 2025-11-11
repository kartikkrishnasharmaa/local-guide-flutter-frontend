import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/appointment_response.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/enums/invoice_type.dart';
import 'package:localguider/ui/invoice/invoice_body.dart';
import 'package:localguider/ui/invoice/invoice_footer.dart';
import 'package:localguider/ui/invoice/invoice_header.dart';
import '../../common_libs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class Invoice extends StatefulWidget {
  TransactionDto transactionDto;
  String customerName;
  String customerPhone;
  Invoice({super.key, required this.transactionDto, required this.customerName, required this.customerPhone});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends BaseState<Invoice, HomeBloc> {

  late InvoiceType invoiceType;
  AppointmentResponse? appointmentDto;

  final GlobalKey _invoiceKey = GlobalKey();

  @override
  void init() {

    if (widget.transactionDto.paymentFor == "appointment") {
      invoiceType = InvoiceType.appointment;
    } else if (widget.transactionDto.paymentFor == "wallet") {
      invoiceType = InvoiceType.topUp;
    } else {
      invoiceType = InvoiceType.nan;
    }

  }

  @override
  void postFrame() {
    if (invoiceType == InvoiceType.appointment) {
      bloc.getAppointmentByTransactionId(widget.transactionDto.id.toString(),
              (response) {
            if (response.success == true) {
              appointmentDto = response.data;
              setState(() {});
            }
          });
    }
    super.postFrame();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      navigatePop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                gap(context, width: 20),
                CustomText(
                  "${widget.transactionDto.transactionId?.replaceAll("_", " ").toUpperCase()}",
                  fontSize: sizing(14, context),
                ),
              ],
            ),
            divider()
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 70,
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              key: _invoiceKey,
              child: Padding(
                padding: EdgeInsets.all(sizing(20, context)),
                child: Column(
                  children: [
                    InvoiceHeader(
                      transactionDto: widget.transactionDto,
                      invoiceType: invoiceType,
                      name: widget.customerName,
                      phone: widget.customerPhone,
                    ),
                    if (invoiceType != InvoiceType.appointment ||
                        (appointmentDto != null))
                      InvoiceBody(
                        transactionDto: widget.transactionDto,
                        invoiceType: invoiceType,
                        appointmentResponse: appointmentDto,
                      ),
                    Spacer(),
                    InvoiceFooter(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: DefaultButton("Download Invoice",
                fontSize: 15,
                iconEnd: Icon(
                  Icons.download,
                  color: $styles.colors.white,
                ), onClick: () async {
              showLoading();
              await _downloadInvoice();
              dismissLoading();
            }),
          )
        ],
      ),
    );
  }

  Future<void> _downloadInvoice() async {
    try {
      RenderRepaintBoundary boundary = _invoiceKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List imageBytes = byteData!.buffer.asUint8List();

      // Convert Image to PDF
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(pdfImage));
          },
        ),
      );

      // Save PDF file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/Invoice_${widget.transactionDto.transactionId}.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
      OpenFile.open(filePath);
    } catch (e) {
      print("Error generating invoice: $e");
    }
  }
}
