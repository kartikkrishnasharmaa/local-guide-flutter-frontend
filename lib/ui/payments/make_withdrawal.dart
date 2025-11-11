import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/main.dart';
import 'package:localguider/ui/payments/withdrawal_success.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../modals/items_selection.dart';
import '../../models/response/withdrawal_model.dart';
import '../../models/selection_model.dart';
import '../../responsive.dart';

class MakeWithdrawal extends StatefulWidget {
  String? userId;
  String? photographerId;
  String? guiderId;

  Function(double amount) refreshCallback;

  MakeWithdrawal({
    super.key,
    this.userId,
    this.photographerId,
    this.guiderId,
    required this.refreshCallback
  });

  @override
  State<MakeWithdrawal> createState() => _MakeWithdrawalState();
}

class _MakeWithdrawalState extends BaseState<MakeWithdrawal, HomeBloc> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _acHolderNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  List<String> allBanks = [
    // National Banks
    'Bank of Baroda',
    'Bank of India',
    'Bank of Maharashtra',
    'Canara Bank',
    'Central Bank of India',
    'Indian Bank',
    'Indian Overseas Bank',
    'Punjab & Sind Bank',
    'Punjab National Bank',
    'State Bank of India',
    'UCO Bank',
    'Union Bank of India',

    // Private Sector Banks
    'Axis Bank Ltd.',
    'Bandhan Bank Ltd.',
    'CSB Bank Ltd.',
    'City Union Bank Ltd.',
    'DCB Bank Ltd.',
    'Dhanlaxmi Bank Ltd.',
    'Federal Bank Ltd.',
    'HDFC Bank Ltd',
    'ICICI Bank Ltd.',
    'Induslnd Bank Ltd',
    'IDFC First Bank Ltd.',
    'Jammu & Kashmir Bank Ltd.',
    'Karnataka Bank Ltd.',
    'Karur Vysya Bank Ltd.',
    'Kotak Mahindra Bank Ltd',
    'Nainital Bank Ltd.',
    'RBL Bank Ltd.',
    'South Indian Bank Ltd.',
    'Tamilnad Mercantile Bank Ltd.',
    'YES Bank Ltd.',
    'IDBI Bank Ltd.',

    // Small Finance Banks
    'Au Small Finance Bank Limited',
    'Capital Small Finance Bank Limited',
    'Equitas Small Finance Bank Limited',
    'Suryoday Small Finance Bank Limited',
    'Ujjivan Small Finance Bank Limited',
    'Utkarsh Small Finance Bank Limited',
    'ESAF Small Finance Bank Limited',
    'Fincare Small Finance Bank Limited',
    'Jana Small Finance Bank Limited',
    'North East Small Finance Bank Limited',
    'Shivalik Small Finance Bank Limited',
    'Unity Small Finance Bank Limited',

    // Payments Banks
    'India Post Payments Bank Limited',
    'Fino Payments Bank Limited',
    'Paytm Payments Bank Limited',
    'Airtel Payments Bank Limited',

    // Regional Rural Banks
    'Andhra Pragathi Grameena Bank',
    'Andhra Pradesh Grameena Vikas Bank',
    'Arunachal Pradesh Rural Bank',
    'Aryavart Bank',
    'Assam Gramin Vikash Bank',
    'Bangiya Gramin Vikash Bank',
    'Baroda Gujarat Gramin Bank',
    'Baroda Rajasthan Kshetriya Gramin Bank',
    'Baroda UP Bank',
    'Chaitanya Godavari Grameena Bank',
    'Chhattisgarh Rajya Gramin Bank',
    'Dakshin Bihar Gramin Bank',
    'Ellaquai Dehati Bank',
    'Himachal Pradesh Gramin Bank',
    'J&K Grameen Bank',
    'Jharkhand Rajya Gramin Bank',
    'Karnataka Gramin Bank',
    'Karnataka Vikas Grameena Bank',
    'Kerala Gramin Bank',
    'Madhya Pradesh Gramin Bank',
    'Madhyanchal Gramin Bank',
    'Maharashtra Gramin Bank',
    'Manipur Rural Bank',
    'Meghalaya Rural Bank',
    'Mizoram Rural Bank',
    'Nagaland Rural Bank',
    'Odisha Gramya Bank',
    'Paschim Banga Gramin Bank',
    'Prathama UP Gramin Bank',
    'Puduvai Bharathiar Grama Bank',
    'Punjab Gramin Bank',
    'Rajasthan Marudhara Gramin Bank',
    'Saptagiri Grameena Bank',
    'Sarva Haryana Gramin Bank',
    'Saurashtra Gramin Bank',
    'Tamil Nadu Grama Bank',
    'Telangana Grameena Bank',
    'Tripura Gramin Bank',
    'Utkal Grameen bank',
    'Uttar Bihar Gramin Bank',
    'Uttarakhand Gramin Bank',
    'Uttarbanga Kshetriya Gramin Bank',
    'Vidharbha Konkan Gramin Bank',

    // Foreign Banks
    'AB Bank Ltd.',
    'American Express Banking Corporation',
    'Australia and New Zealand Banking Group Ltd.',
    'Barclays Bank Plc.',
    'Bank of America',
    'Bank of Bahrain & Kuwait BSC',
    'Bank of Ceylon',
    'Bank of China',
    'Bank of Nova Scotia',
    'BNP Paribas',
    'Citibank N.A.',
    'Cooperatieve Rabobank U.A.',
    'Credit Agricole Corporate & Investment Bank',
    'Credit Suisse A.G',
    'CTBC Bank Co., Ltd.',
    'DBS Bank India Limited',
    'Deutsche Bank',
    'Doha Bank Q.P.S.C',
    'Emirates Bank NBD',
    'First Abu Dhabi Bank PJSC',
    'FirstRand Bank Ltd',
    'HSBC Ltd',
    'Industrial & Commercial Bank of China Ltd.',
    'Industrial Bank of Korea',
    'J.P. Morgan Chase Bank N.A.',
    'JSC VTB Bank',
    'KEB Hana Bank',
    'Kookmin Bank',
    'Krung Thai Bank Public Co. Ltd.',
    'Mashreq Bank PSC',
    'Mizuho  Bank Ltd.',
    'MUFG Bank, Ltd.',
    'NatWest Markets Plc',
    'NongHyup Bank',
    'PT Bank Maybank Indonesia TBK',
    'Qatar National Bank (Q.P.S.C.)',
    'Sberbank',
    'SBM Bank (India) Limited',
    'Shinhan Bank',
    'Societe Generale',
    'Sonali Bank PLC',
    'Standard Chartered Bank',
    'Sumitomo Mitsui Banking Corporation',
    'United Overseas Bank Ltd',
    'Woori Bank',
  ];

  final _banksList = <SelectionModel>[];
  SelectionModel? _bank;

  final GlobalKey<FormState> _bankDetailsValidationKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _amountValidationKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _upiValidationKey = GlobalKey<FormState>();

  bool isUpi = false;
  bool isBankDetails = false;

  double charge = 0.0;
  double amount = 0.0;

  @override
  void init() {
    for (var element in allBanks) {
      _banksList.add(SelectionModel(
        title: element,
        selected: false,
      ));
    }
  }

  @override
  void postFrame() {
    double chargePercentage = $appUtils.getSettings()?.withdrawalCharge?.toDouble() ?? .0;
    _amountController.addListener(() {
      $logger.log(message: "Test ${_amountController.text.toString()}");
      if(_amountController.text.toString().isNotEmpty) {
        $logger.log(message: "Test 22 ${_amountController.text.toString()}");
        double newAmount = double.parse(_amountController.text.toString());
        $logger.log(message: "Test 33 $newAmount $amount ${_amountController.text.toString()}");
        if(newAmount != amount) {
          setState(() {
            amount = newAmount;
            charge = (chargePercentage * amount) / 100;
            $logger.log(message: "Test 44 $newAmount $amount $charge ${_amountController.text.toString()}");
          });
        }
      } else {
        setState(() {
          amount = 0.0;
          charge = 0.0;
        });
      }
    });
    super.postFrame();
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    _bankNameController.text = _bank?.title ?? "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        title: CustomText(
          "Make Withdrawal",
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
      body: Padding(
        padding: EdgeInsets.all(sizing(10, context)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gap(context, height: 20),
              Form(
                key: _amountValidationKey,
                child: InputField(
                  hint: "Amount",
                  disableLabel: true,
                  maxLength: 15,
                  isNumeric: true,
                  controller: _amountController,
                  validator: (text) {
                    if (text == null || text.isEmpty == true) {
                      return "Please enter amount";
                    } else if(double.parse(text) < ($appUtils.getSettings()?.minimumWithdrawal ?? 100)) {
                      return "Minimum amount should be ${$appUtils.getSettings()?.minimumWithdrawal ?? 100}";
                    }
                    return null;
                  },
                ),
              ),
              if(charge > .0) Padding(
                padding: EdgeInsets.only(top: sizing(5, context)),
                child: CustomText("*Charge: ₹$charge", color: $styles.colors.greyMedium),
              ),
              Form(
                  key: _bankDetailsValidationKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gap(context, height: 20),
                      CustomText(
                        "Bank Account Details",
                        color: $styles.colors.blue,
                      ),
                      gap(context, height: 10),
                      InputField(
                        hint: "Select Bank",
                        disableLabel: true,
                        isDisable: true,
                        iconEnd: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: $styles.colors.black,
                        ),
                        controller: _bankNameController,
                        validator: (text) {
                          if (text == null || text.isEmpty == true) {
                            return "Please select your bank.";
                          }
                          return null;
                        },
                        onClick: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: 1,
                                  child: ItemSelectionSheet(
                                    title: "Select Bank",
                                    selectedItem: _bank,
                                    onItemSelected: (newBank) {
                                      _onBankChange(newBank);
                                    },
                                    list: _banksList,
                                  ),
                                );
                              });
                        },
                      ),
                      gap(context, height: 15),
                      InputField(
                        hint: "Account Number",
                        disableLabel: true,
                        maxLength: 25,
                        isNumeric: true,
                        controller: _accountNumberController,
                        validator: (text) {
                          if (text == null || text.isEmpty == true) {
                            return "Please enter account number.";
                          }
                          return null;
                        },
                      ),
                      gap(context, height: 15),
                      InputField(
                        hint: "Account Holder Name",
                        disableLabel: true,
                        controller: _acHolderNameController,
                        validator: (text) {
                          if (text == null || text.isEmpty == true) {
                            return "Please enter account holder name.";
                          }
                          return null;
                        },
                      ),
                      gap(context, height: 15),
                      InputField(
                        hint: "IFSC",
                        disableLabel: true,
                        maxLength: 20,
                        controller: _ifscController,
                        validator: (text) {
                          if (text == null || text.isEmpty == true) {
                            return "Please enter IFS Code.";
                          }
                          return null;
                        },
                      ),
                      gap(context, height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: divider(color: $styles.colors.greyMedium)),
                          gap(context, width: 10),
                          CustomText(
                            "OR",
                            color: $styles.colors.blue,
                          ),
                          gap(context, width: 10),
                          Expanded(
                              child: divider(color: $styles.colors.greyMedium)),
                        ],
                      ),
                    ],
                  )),
              gap(context, height: 15),
              Form(
                key: _upiValidationKey,
                child: InputField(
                  hint: "UPI ID",
                  disableLabel: true,
                  maxLength: 15,
                  controller: _upiController,
                  validator: (text) {
                    if (text == null || text.isEmpty == true) {
                      return "Please UPI Id.";
                    }
                    return null;
                  },
                ),
              ),
              gap(context, height: 20),
              DefaultButton(
                "Withdraw",
                onClick: () {
                  if(_validate()) {
                    _makeWithdrawal();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _validate() {
    if (_amountValidationKey.currentState?.validate() == true) {
      if(double.parse(_amountController.text.toString()) < ($appUtils.getSettings()?.minimumWithdrawal?.toDouble() ?? 0.0))  {
        snackBar("Failed!", "Minimum withdrawal should be ${$appUtils.getSettings()?.minimumWithdrawal?.toStringAsFixed(2)}");
        return false;
      }
      if (_accountNumberController.text.toString().isNotEmpty) {
        // Go with Bank Details
        isBankDetails = true;
        isUpi = false;
        if (_bankDetailsValidationKey.currentState?.validate() ==
            true) {
          return true;
        }
      } else if (_upiController.text.toString().isNotEmpty) {
        // Go with UPI id
        isBankDetails = false;
        isUpi = true;
        if (_upiValidationKey.currentState?.validate() == true) {
          return true;
        }
      } else {
        if (_bankDetailsValidationKey.currentState?.validate() !=
            true) {
          return false;
        }
      }
    }
    return false;
  }

  _makeWithdrawal() {
    bloc.makeWithdrawal(
        photographerId: widget.photographerId,
        guiderId: widget.guiderId,
        amount: amount,
        amountToBeSettled: amount - charge,
        charge: charge,
        paymentToken: "payment_${DateTime.now().millisecondsSinceEpoch}",
        bankName: _bank?.title,
        accountNumber: _accountNumberController.text.toString(),
        accountHolderName: _acHolderNameController.text.toString(),
        ifsc: _ifscController.text.toString(),
        upiId: _upiController.text.toString(),
        callback: (p0) {
          _handleResponse(p0);
        });
  }

  _handleResponse(BaseCallback<WithdrawalModel> callback) {
    dismissLoading();
    if(callback.success == true) {
      widget.refreshCallback(double.parse(_amountController.text.toString()));
      navigatePop(context);
      navigate(const WithdrawalSuccess());
    } else {
      snackBar("Failed!", callback.message ?? $strings.SOME_THING_WENT_WRONG);
    }
  }

  _onBankChange(newBank) {
    setState(() {
      _bank = newBank;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _acHolderNameController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
  }
}
