import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';

import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../models/response/review_dto.dart';
import '../../responsive.dart';
import '../rows/row_review.dart';

class AllReviews extends StatefulWidget {

  String? placeId;
  String? photographerId;
  String? guiderId;
  AllReviews({super.key, this.placeId, this.photographerId, this.guiderId});

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends BaseState<AllReviews, HomeBloc> {

  final int _pageSize = 10;
  int _page = 1;

  final PagingController<int, ReviewDto> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;
    _pagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      bloc.getReviews(user.id.toString(), widget.photographerId, widget.guiderId, widget.placeId, (p0) {
        _handleResponse(p0);
      });
    });

  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
            onPressed: () {
              navigatePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: $styles.colors.white,
            )),
        centerTitle: true,
        title: CustomText(
          "All Reviews",
          color: $styles.colors.white,
          fontSize: titleSize(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizing(10, context)),
          child: PagedListView<int, ReviewDto>(
            shrinkWrap: true,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ReviewDto>(
                itemBuilder: (context, item, index) => RowReview(review: item),
                noItemsFoundIndicatorBuilder: (context) =>  Padding(
                  padding: EdgeInsets.all(sizing(50, context)),
                  child: Center(child: CustomText("No Result Found")),
                ),
                firstPageProgressIndicatorBuilder: (context) => Center(
                    child: CircularProgressIndicator(
                      color: $styles.colors.blue,
                    )),
                firstPageErrorIndicatorBuilder: (context) =>
                    Center(child: CustomText("No Result Found"))),
          ),
        ),
      ),
    );
  }

  _handleResponse(BaseListCallback<ReviewDto>? event) {
    if (event?.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          _page++;
          _pagingController.appendPage(
              newItems, _page);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    } else {
      _pagingController.error = event?.message;
    }
  }
}
