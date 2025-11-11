import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/responsive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../common_libs.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../utils/time_utils.dart';

class AddPayment extends StatefulWidget {
  String? userId;
  String? photographerId;
  String? guiderId;

  Function(bool, double) callback;

  AddPayment({super.key, this.userId, this.photographerId, this.guiderId, required this.callback});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends BaseState<AddPayment, HomeBloc> {

  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Razorpay _razorpay = Razorpay();

  @override
  void init() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText(
          "Add Balance",
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(sizing(10, context)),
          child: Column(
            children: [
              gap(context, height: 20),
              InputField(
                hint: "Amount",
                disableLabel: true,
                isUsername: true,
                maxLength: 15,
                isNumeric: true,
                controller: _amountController,
                validator: (text) {
                  if (text == null || text.isEmpty == true) {
                    return "Please enter amount";
                  } else if(double.parse(text) < ($appUtils.getSettings()?.minimumAddBalance?.toDouble() ?? 0.0)) {
                    return "Minimum amount should be ${$appUtils.getSettings()?.minimumAddBalance?.toStringAsFixed(2)}";
                  }
                  return null;
                },
              ),
              gap(context, height: 20),
              DefaultButton(
                "Add",
                onClick: () {
                  if (_formKey.currentState!.validate()) {
                    var amount = double.parse(_amountController.text.toString());
                    if(amount < ($appUtils.getSettings()?.minimumAddBalance?.toDouble() ?? 0.0))  {
                      snackBar("Failed!", "Minimum amount should be ${$appUtils.getSettings()?.minimumAddBalance?.toStringAsFixed(2)}");
                      return false;
                    }
                    bloc.createTransaction(
                        userId: widget.userId,
                        photographerId: widget.photographerId,
                        guiderId: widget.guiderId,
                        paymentToken: Random.secure().nextInt(10000).toString(),
                        amount: amount,
                        callback: (transaction) {
                          _openRazorpay(amount, transaction.data?.paymentToken ?? "");
                        });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openRazorpay(double amount, orderId) {
    bloc.showLoading();
    var options = {
      'key': $appUtils.getSettings()?.razorpayAPIKey,
      'amount': amount * 100,
      'name': 'Local Guider',
      'order_id': orderId,
      'description':
      'Payment by ${user.name} on ${TimeUtils.format(DateTime.now(), format: TimeUtils.yyyyMMdd)}',
      'timeout': 60,
      'prefill': {
        'contact': user.phone,
      }
    };
    _razorpay.open(options);
  }

  void _updateTransaction(paymentToken) {
    bloc.updateTransaction(
        paymentToken: paymentToken,
        paymentStatus: "Success",
        callback: (p0) {
          if(p0.success == true) {
            widget.callback(true, p0.data!.amount?.toDouble() ?? 0.0);
            navigatePop(context);
          } else {
            snackBar("Failed!", p0.message ?? "Something went wrong");
          }
        });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    bloc.dismissLoading();
    _updateTransaction(response.orderId ?? "");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    bloc.dismissLoading();
    snackBar("Failed!", response.message ?? "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    bloc.dismissLoading();
    snackBar("Failed!", "Please select method from menu");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

}
