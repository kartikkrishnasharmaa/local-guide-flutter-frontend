import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/components/divider.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/withdrawal_model.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/admin/withdrawals/withdrawal_details.dart';
import 'package:localguider/ui/payments/row_withdrawals.dart';
import 'package:localguider/user_role.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../network/network_const.dart';
import '../../utils/time_utils.dart';
import 'make_withdrawal.dart';

class Withdrawals extends StatefulWidget {
  UserRole userRole;
  PhotographerDto? dto;
  Function()? refreshCallback;

  Withdrawals(
      {super.key,
      required this.userRole,
      this.dto,
      this.refreshCallback});

  @override
  State<Withdrawals> createState() => _WithdrawalsState();
}

class _WithdrawalsState extends BaseState<Withdrawals, HomeBloc> {

  final int _pageSize = 10;
  int _page = 1;

  final PagingController<int, WithdrawalModel> _transactionsPagingController =
      PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;
    _transactionsPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      bloc.getWithdrawals(
          photographerId: widget.userRole == UserRole.PHOTOGRAPHER && !$isAdmin
              ? user.pid.toString()
              : null,
          guiderId:
              widget.userRole == UserRole.GUIDER && !$isAdmin ? user.gid.toString() : null,
          page: pageKey,
          callback: _handleResponse);
    });
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      appBar: AppBar(
          backgroundColor: $styles.colors.blue,
          title: CustomText(
            "Withdrawals",
            color: $styles.colors.white,
            fontSize: titleSize(),
          ),
          centerTitle: true,
          actions: [
            if(widget.userRole == UserRole.ADMIN) CustomInkWell(
                onTap: () {
                   _downloadWithdrawals();
                },
                child:  Padding(
                  padding: EdgeInsets.only(right: sizing(15, context)),
                  child: Icon(Icons.download_rounded,
                      color: $styles.colors.white),
                )),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            ),
            onPressed: () {
              navigatePop(context);
            },
          )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!$isAdmin)
            Padding(
              padding: EdgeInsets.all(sizing(15, context)),
              child: Container(
                padding: EdgeInsets.all(sizing(20, context)),
                decoration: BoxDecoration(
                    color: $styles.colors.blue,
                    borderRadius: BorderRadius.circular(sizing(20, context))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          "Available Balance",
                          fontSize: sizing(20, context),
                          isBold: true,
                          color: $styles.colors.white,
                        ),
                        gap(context, height: 10),
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: Icon(Icons.account_balance_wallet_rounded,
                                color: $styles.colors.white),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          "₹ ${(widget.dto?.balance ?? 0.0).toStringAsFixed(2)}",
                          fontSize: sizing(20, context),
                          isBold: true,
                          color: $styles.colors.white,
                        ),
                        gap(context, height: 10),
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: DefaultButton("Withdraw",
                                textColor: $styles.colors.white,
                                padding: 10,
                                strokeColor: $styles.colors.white,
                                stroke: 1, onClick: () {
                              navigate(MakeWithdrawal(
                                photographerId:
                                    widget.userRole == UserRole.PHOTOGRAPHER
                                        ? widget.dto?.id.toString()
                                        : null,
                                guiderId: widget.userRole == UserRole.GUIDER
                                    ? widget.dto?.id.toString()
                                    : null,
                                refreshCallback: _refresh,
                              ));
                            }),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (!$isAdmin) divider(),
          gap(context, height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () => _transactionsPagingController.refresh(),
              ),
              child: PagedListView<int, WithdrawalModel>(
                pagingController: _transactionsPagingController,
                shrinkWrap: true,
                builderDelegate: PagedChildBuilderDelegate<WithdrawalModel>(
                    itemBuilder: (context, item, index) => RowWithdrawals(
                          withdrawalDto: item,
                          onClick: (model) {
                            navigate(WithdrawalDetails(
                              withdrawalModel: model,
                              refreshCallback: () {
                                _transactionsPagingController.refresh();
                              },
                            ));
                          },
                        ),
                    noItemsFoundIndicatorBuilder: (context) {
                      return Center(
                          child: Padding(
                        padding: EdgeInsets.all(sizing(40, context)),
                        child: CustomText("No Withdrawal Found"),
                      ));
                    },
                    firstPageProgressIndicatorBuilder: (context) => Center(
                            child: CircularProgressIndicator(
                          color: $styles.colors.blue,
                        )),
                    firstPageErrorIndicatorBuilder: (context) => Padding(
                          padding: EdgeInsets.all(sizing(40, context)),
                          child: Center(child: CustomText("No Result Found")),
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _refresh(double amount) {
    widget.dto?.balance = (widget.dto?.balance?.toDouble() ?? 0.0) - amount;
    setState(() {
      _transactionsPagingController.refresh();
      if(widget.refreshCallback != null) {
        widget.refreshCallback!();
      }
    });
  }

  void _downloadWithdrawals() {
    disableDialogLoading = false;
    AdminBloc().download(EndPoints.DOWNLOAD_WITHDRAWALS, (p0) async {
      if(p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(p0.data!, "Withdrawals_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  _handleResponse(BaseListCallback<WithdrawalModel> event) {
    $logger.log(message: "Test 3 <><>  ${event.data?.length}");
    if (event.success == true) {
      try {
        final newItems = event.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        $logger.log(message: "${event.data?.length}  $isLastPage");
        if (isLastPage) {
          _transactionsPagingController.appendLastPage(newItems);
        } else {
          _page++;
          _transactionsPagingController.appendPage(
              newItems, _page);
        }
      } catch (error) {
        $logger.log(message: "Test 4 $error");
        _transactionsPagingController.error = error;
      }
    } else {
      _transactionsPagingController.error = event.message;
    }
  }
}
