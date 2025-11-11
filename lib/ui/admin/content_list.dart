import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/components/default_button.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/admin/places/add_edit_place.dart';
import 'package:localguider/ui/admin/places/place_details_admin.dart';
import 'package:localguider/ui/enums/approval_status.dart';
import 'package:localguider/ui/join/join_request_status.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/utils/time_utils.dart';
import '../../base/base_callback.dart';
import '../../common_libs.dart';
import '../../components/custom_ink_well.dart';
import '../../components/custom_text.dart';
import '../../components/input_field.dart';
import '../../main.dart';
import '../../modals/reason_of_decline.dart';
import '../../models/place_model.dart';
import '../../models/response/photographer_dto.dart';
import '../../network/network_const.dart';
import '../../responsive.dart';
import '../../user_role.dart';
import '../rows/row_common_vertical.dart';

class ContentList extends StatefulWidget {
  SearchTypes searchType;

  ContentList({super.key, required this.searchType});

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends BaseState<ContentList, AdminBloc> {
  final TextEditingController _searchController = TextEditingController();

  final int _pageSize = 10;
  int _page = 1;

  final PagingController<int, PhotographerDto> _photographerPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, PlaceModel> _placesPagingController =
      PagingController(firstPageKey: 1);

  String get _searchText => _searchController.text;

  String _status = ApprovalStatus.approved.value;

  final List<String> _statusList = [
    ApprovalStatus.approved.value,
    ApprovalStatus.inReview.value,
    ApprovalStatus.declined.value
  ];

  @override
  void init() {
    disableDialogLoading = true;

    _photographerPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      if (widget.searchType == SearchTypes.photographer ||
          widget.searchType == SearchTypes.guider) {
        bloc.fetchPhotographers(
            widget.searchType == SearchTypes.guider
                ? UserRole.GUIDER
                : UserRole.PHOTOGRAPHER,
            pageKey,
            _status,
            _searchText,
            _handlePhotographerResponse);
      }
    });

    _placesPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      if (widget.searchType == SearchTypes.place) {
        bloc.fetchPlaces(pageKey, _searchText, (p0) {
          _handlePlacesResponse(p0);
        });
      }
    });
  }

  @override
  void postFrame() {
    super.postFrame();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        if (widget.searchType == SearchTypes.place ||
            widget.searchType == SearchTypes.placePick) {
          _placesPagingController.refresh();
        } else {
          _photographerPagingController.refresh();
        }
      }
    });
  }

  @override
  AdminBloc setBloc() => AdminBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.secondarySurface,
      appBar: AppBar(
        backgroundColor: $styles.colors.secondarySurface,
        automaticallyImplyLeading: false,
        toolbarHeight: sizing(120, context),
        title: Column(
          children: [
            InputField(
                bgColor: $styles.colors.white,
                focusStrokeColor: $styles.colors.white,
                enabledStrokeColor: $styles.colors.white,
                iconEnd: CustomInkWell(
                    onTap: () {
                      if (widget.searchType == SearchTypes.photographer) {
                        _downloadPhotographers();
                      } else if (widget.searchType == SearchTypes.guider) {
                        _downloadGuiders();
                      } else if (widget.searchType == SearchTypes.place) {
                        _downloadPlaces();
                      }
                    },
                    child: Icon(Icons.download_rounded,
                        color: $styles.colors.black)),
                iconStart: CustomInkWell(
                    onTap: () {
                      navigatePop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: $styles.colors.black)),
                disableLabel: true,
                hint:
                    "Search ${(widget.searchType == SearchTypes.place || widget.searchType == SearchTypes.placePick) ? "Places" : widget.searchType == SearchTypes.photographer ? "Photographers" : "Guiders"}",
                controller: _searchController),
            gap(context, height: 10),
            if (widget.searchType != SearchTypes.place)
              SizedBox(
                height: sizing(40, context),
                child: Center(
                    child: Row(
                  children: [
                    ...List.generate(
                        _statusList.length,
                        (index) => _rowStatus(_statusList[index], (p0) {
                              setState(() {
                                _status = _statusList[index];
                                _photographerPagingController.refresh();
                              });
                            }))
                  ],
                )),
              ),
            if (widget.searchType == SearchTypes.place)
              gap(context, height: 10),
            if (widget.searchType == SearchTypes.place)
              DefaultButton("Add New Place", onClick: () {
                navigate(AddEditPlace(
                  refreshCallback: (p0) {
                    _placesPagingController.refresh();
                  },
                ));
              })
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _refresh(),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              gap(context, height: 20),
              if (widget.searchType == SearchTypes.photographer ||
                  widget.searchType == SearchTypes.guider)
                PagedListView<int, PhotographerDto>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: _photographerPagingController,
                  builderDelegate: PagedChildBuilderDelegate<PhotographerDto>(
                      itemBuilder: (context, item, index) => RowCommonVertical(
                            title: item.firmName ?? "",
                            subtitle: item.placeName ?? "",
                            imageUrl: item.featuredImage ?? "",
                            likeObjId: "",
                            inAdmin: true,
                            rating: item.rating?.toDouble() ?? 0.0,
                            showResponseButton:
                                _status == ApprovalStatus.inReview.value,
                            onResponse: (accept, decline) {
                              _changeStatus(
                                  accept, decline, item.id.toString());
                            },
                            onClick: () {
                              navigate(JoinRequestStatus(
                                  dtoId: item.id.toString(),
                                  isAdmin: true,
                                  userRole: widget.searchType ==
                                          SearchTypes.photographer
                                      ? UserRole.PHOTOGRAPHER
                                      : UserRole.GUIDER, refreshCallback: () {
                                    _photographerPagingController.refresh();
                              },));
                            },
                          ),
                      firstPageProgressIndicatorBuilder: (context) => Center(
                              child: CircularProgressIndicator(
                            color: $styles.colors.blue,
                          )),
                      firstPageErrorIndicatorBuilder: (context) =>
                          Center(child: CustomText("No Result Found"))),
                ),
              if (widget.searchType == SearchTypes.place ||
                  widget.searchType == SearchTypes.placePick)
                PagedListView<int, PlaceModel>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: _placesPagingController,
                  builderDelegate: PagedChildBuilderDelegate<PlaceModel>(
                      itemBuilder: (context, item, index) => RowCommonVertical(
                            title: item.placeName ?? "",
                            subtitle: item.state ?? "",
                            inAdmin: true,
                            likeObjId: "",
                            showDeleteButton: true,
                            onDelete: () {
                              _showDeletePlaceConfirmation(item);
                            },
                            imageUrl: item.featuredImage ?? "",
                            rating: item.rating?.toDouble() ?? 0.0,
                            onClick: () {
                              navigate(PlaceDetailsAdmin(
                                  placeModel: item,
                                  refreshCallback: () {
                                    _placesPagingController.refresh();
                                  }));
                            },
                          ),
                      firstPageProgressIndicatorBuilder: (context) => Center(
                              child: CircularProgressIndicator(
                            color: $styles.colors.blue,
                          )),
                      firstPageErrorIndicatorBuilder: (context) =>
                          Center(child: CustomText("No Result Found"))),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _refresh() {
    if (widget.searchType == SearchTypes.place) {
      _placesPagingController.refresh();
    } else {
      _photographerPagingController.refresh();
    }
  }

  _showDeletePlaceConfirmation(PlaceModel place) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: "Delete Place?",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc: "Are you sure you want to delete this place?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
              disableDialogLoading = false;
              bloc.deletePlace(place.id.toString(), (p0) {
                disableDialogLoading = true;
                if (p0.success == true) {
                  _placesPagingController.refresh();
                } else {
                  snackBar(
                      "Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
                }
              });
            },
            btnCancelOnPress: () {})
        .show();
  }

  void _changeStatus(accept, decline, dtoId) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.all(sizing(15, context)),
            title: accept ? "Accept Request!" : "Decline Request",
            dialogBackgroundColor: $styles.colors.background,
            titleTextStyle: TextStyle(
              color: $styles.colors.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descTextStyle: TextStyle(
              color: $styles.colors.title,
            ),
            desc:
                "Are you sure you want to ${accept ? "Accept" : "Decline"} this request?",
            btnCancelText: "Not Now",
            btnOkText: "Yes",
            btnOkOnPress: () {
             if(decline == true) {
               Get.dialog(
                   barrierDismissible: false,
                   Dialog(
                       backgroundColor: $styles.colors.white,
                       child: ReasonOfDecline(
                           title: "Reason of Decline!",
                           onDone: (text) {
                             $logger.log(message: "message >>>>>>>>>>>>>>>>>>>> Done Click");
                             _respond(
                                 accept, decline, dtoId, text);
                           }))
               );
             } else {
               _respond(accept, decline, dtoId, null);
             }
            },
            btnCancelOnPress: () {})
        .show();
  }

  void _respond(accept, decline, dtoId, reason) {
    bloc.respondToPhotographer(
        widget.searchType == SearchTypes.photographer
            ? UserRole.PHOTOGRAPHER
            : UserRole.GUIDER,
        dtoId,
        accept
            ? ApprovalStatus.approved.value
            : ApprovalStatus.declined.value, reason, (p0) {
      if (p0.success == true) {
        snackBar(accept ? "Accepted!" : "Declined!",
            "Request status updated");
        _photographerPagingController.refresh();
      } else {
        snackBar(
            "Failed", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  _handlePhotographerResponse(event) {
    if (event?.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        if (isLastPage) {
          _photographerPagingController.appendLastPage(newItems);
        } else {
          _page++;
          _photographerPagingController.appendPage(
              newItems, _page);
        }
      } catch (error) {
        _photographerPagingController.error = error;
      }
    } else {
      _photographerPagingController.error = event?.message;
    }
  }

  _handlePlacesResponse(BaseListCallback<PlaceModel> event) {
    $logger.log(message: "Test 3 <><>  ${event.data?.length}");
    if (event.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        $logger.log(message: "${event?.data?.length}  $isLastPage");
        if (isLastPage) {
          _placesPagingController.appendLastPage(newItems);
        } else {
          _page++;
          _placesPagingController.appendPage(newItems, _page);
        }
      } catch (error) {
        $logger.log(message: "Test 4 $error");
        _placesPagingController.error = error;
      }
    } else {
      _placesPagingController.error = event.message;
    }
  }

  _rowStatus(text, Function(String) onClick) {
    return InkWell(
      onTap: () {
        onClick(text);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizing(7, context)),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: sizing(6, context), vertical: sizing(5, context)),
          decoration: BoxDecoration(
              color: text == _status
                  ? $styles.colors.blue
                  : $styles.colors.greyLight,
              borderRadius: BorderRadius.circular(sizing(15, context))),
          child: CustomText(
            text,
            color:
                text == _status ? $styles.colors.white : $styles.colors.black,
          ),
        ),
      ),
    );
  }

  void _downloadPhotographers() {
    disableDialogLoading = false;
    bloc.download(EndPoints.DOWNLOAD_PHOTOGRAPHERS, (p0) async {
      if (p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(
            p0.data!, "Photographers_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  void _downloadGuiders() {
    disableDialogLoading = false;
    bloc.download(EndPoints.DOWNLOAD_GUIDERS, (p0) async {
      if (p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(
            p0.data!, "Guiders_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  void _downloadPlaces() {
    disableDialogLoading = false;
    bloc.download(EndPoints.DOWNLOAD_PLACES, (p0) async {
      if (p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(
            p0.data!, "Places_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _placesPagingController.dispose();
    _photographerPagingController.dispose();
    super.dispose();
  }
}
