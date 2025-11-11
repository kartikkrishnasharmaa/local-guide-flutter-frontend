import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/models/response/transaction_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/payments/row_payment.dart';
import 'package:localguider/user_role.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../network/network_const.dart';
import '../../utils/time_utils.dart';
import '../admin/network/admin_bloc.dart';

class Transactions extends StatefulWidget {
  UserRole userRole;
  String? dtoId;
  PhotographerDto? dto;

  Transactions({super.key, required this.userRole, this.dtoId, this.dto});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends BaseState<Transactions, HomeBloc> {
  final int _pageSize = 10;
  int _page = 1;

  final PagingController<int, TransactionDto> _transactionsPagingController =
      PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;
    _transactionsPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      bloc.transactionList(
          userId: widget.userRole == UserRole.JUST_USER
              ? (widget.dtoId ?? user.id.toString())
              : null,
          photographerId: widget.userRole == UserRole.PHOTOGRAPHER
              ? (widget.dtoId ?? user.pid.toString())
              : null,
          guiderId: widget.userRole == UserRole.GUIDER
              ? (widget.dtoId ?? user.gid.toString())
              : null,
          isAdmin: widget.userRole == UserRole.ADMIN,
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
            "Transaction",
            color: $styles.colors.white,
            fontSize: titleSize(),
          ),
          centerTitle: true,
          actions: [
            if (widget.userRole == UserRole.ADMIN)
              CustomInkWell(
                  onTap: () {
                    _downloadTransactions();
                  },
                  child: Padding(
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
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _transactionsPagingController.refresh(),
        ),
        child: PagedListView<int, TransactionDto>(
          pagingController: _transactionsPagingController,
          builderDelegate: PagedChildBuilderDelegate<TransactionDto>(
              itemBuilder: (context, item, index) => RowPayment(
                    transactionDto: item,
                    isAdmin: widget.userRole == UserRole.ADMIN,
                    customerName: widget.userRole == UserRole.JUST_USER
                        ? (user.name ?? "")
                        : widget.userRole == UserRole.PHOTOGRAPHER ||
                                widget.userRole == UserRole.GUIDER
                            ? (widget.dto?.firmName ?? "")
                            : "",
                customerPhone: widget.userRole == UserRole.JUST_USER
                        ? (user.phone ?? "")
                        : widget.userRole == UserRole.PHOTOGRAPHER ||
                                widget.userRole == UserRole.GUIDER
                            ? (widget.dto?.phone ?? "")
                            : "",

                  ),
              firstPageProgressIndicatorBuilder: (context) => Center(
                      child: CircularProgressIndicator(
                    color: $styles.colors.blue,
                  )),
              firstPageErrorIndicatorBuilder: (context) =>
                  Center(child: CustomText("No Result Found"))),
        ),
      ),
    );
  }

  void _downloadTransactions() {
    disableDialogLoading = false;
    AdminBloc().download(EndPoints.DOWNLOAD_TRANSACTIONS, (p0) async {
      if (p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(
            p0.data!, "Transaction_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  _handleResponse(BaseListCallback<TransactionDto> event) {
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
          _transactionsPagingController.appendPage(newItems, _page);
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
