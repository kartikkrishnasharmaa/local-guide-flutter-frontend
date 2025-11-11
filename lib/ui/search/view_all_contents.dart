import 'dart:convert';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_callback.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/blocs/home_bloc.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/models/place_model.dart';
import 'package:localguider/models/response/photographer_dto.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/ui/photographers/photographer_details.dart';
import 'package:localguider/ui/place/place_details.dart';
import 'package:localguider/ui/rows/row_common_vertical.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/user_role.dart';

import '../../common_libs.dart';
import '../../models/wishlist.dart';

class ViewAllContent extends StatefulWidget {
  SearchTypes searchType = SearchTypes.place;
  String? placeId;
  ViewAllContent({super.key, required this.searchType, this.placeId});

  @override
  State<ViewAllContent> createState() => _ViewAllContentState();
}

class _ViewAllContentState extends BaseState<ViewAllContent, HomeBloc> {
  final TextEditingController _searchController = TextEditingController();

  final int _pageSize = 10;
  int _page= 1;

  final PagingController<int, PhotographerDto> _photographerPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, PlaceModel> _placesPagingController =
      PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;

    double lat = user.latitude?.toDouble() ?? 0.0;
    double lng = user.longitude?.toDouble() ?? 0.0;

    _photographerPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      if (user.id != null) {
        if (widget.searchType == SearchTypes.photographer) {
         widget.placeId != null ? bloc.getPhotographersByPlace(widget.placeId,  (p0) { _handlePhotographerResponse(p0); }) :  bloc.getPhotographers(
              lat, lng, pageKey, "",  (p0) { _handlePhotographerResponse(p0); });
        } else {
          widget.placeId != null ? bloc.getGuidersByPlace(widget.placeId,  (p0) { _handlePhotographerResponse(p0); }) : bloc.getGuiders(lat, lng, pageKey, "",  (p0) { _handlePhotographerResponse(p0); });
        }
      }
    });

    _placesPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      if (widget.searchType == SearchTypes.place) {
        _page = pageKey;
        bloc.getPlaces(lat, lng, pageKey, "", (p0) {
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
        if (widget.searchType == SearchTypes.place) {
          _placesPagingController.refresh();
        } else {
          _photographerPagingController.refresh();
        }
      }
    });
  }

  @override
  HomeBloc setBloc() => HomeBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.secondarySurface,
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: $styles.colors.white,
          ),
        ),
        centerTitle: true,
        title: CustomText(
          "All ${widget.searchType == SearchTypes.place ? "Places" : widget.searchType == SearchTypes.photographer ? "Photographers" : "Guiders"}",
          color: $styles.colors.white,
          fontSize: titleSize(),
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
                            likeObjId: "${widget.searchType == SearchTypes.photographer ? UserRole.PHOTOGRAPHER.name : UserRole.GUIDER.name}_${item.id}",
                            imageUrl: item.featuredImage ?? "",
                            rating: item.rating?.toDouble() ?? 0.0,
                            onFavClick: (b) {
                              if (b) {
                                _addToWishlistPhotographer(
                                    item,
                                    widget.searchType == SearchTypes.photographer
                                        ? UserRole.PHOTOGRAPHER.name
                                        : UserRole.GUIDER.name);
                              } else {
                                _removeFromWishlistPhotographer(
                                    item,
                                    widget.searchType == SearchTypes.photographer
                                        ? UserRole.PHOTOGRAPHER.name
                                        : UserRole.GUIDER.name);
                              }
                            },
                            onClick: () {
                              navigate(PhotographerDetails(
                                  dto: item,
                                  userRole: widget.searchType ==
                                          SearchTypes.photographer
                                      ? UserRole.PHOTOGRAPHER
                                      : UserRole.GUIDER, refreshCallback:  () {
                                    _photographerPagingController.refresh();
                              },));
                            },
                          ),
                      firstPageProgressIndicatorBuilder: (context) => Center(
                              child: Padding(
                            padding: EdgeInsets.all(sizing(30, context)),
                            child: CircularProgressIndicator(
                              color: $styles.colors.blue,
                            ),
                          )),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                              child: Padding(
                            padding: EdgeInsets.all(sizing(40, context)),
                            child: CustomText("No Result Found"),
                          ))),
                ),
              if (widget.searchType == SearchTypes.place)
                PagedListView<int, PlaceModel>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: _placesPagingController,
                  builderDelegate: PagedChildBuilderDelegate<PlaceModel>(
                      itemBuilder: (context, item, index) => RowCommonVertical(
                            title: item.placeName ?? "",
                            subtitle: item.state ?? "",
                            likeObjId: "place_${item.id}",
                            imageUrl: item.featuredImage ?? "",
                            rating: item.rating?.toDouble() ?? 0.0,
                            onFavClick: (b) {
                              if (b) {
                                _addToWishlistPlace(item);
                              } else {
                                _removeFromWishlistPlace(item);
                              }
                            },
                            onClick: () {
                              navigate(PlaceDetails(placeModel: item, refreshCallback: () {
                                _placesPagingController.refresh();
                              }));
                            },
                          ),
                      firstPageProgressIndicatorBuilder: (context) => Center(
                              child: Padding(
                            padding: EdgeInsets.all(sizing(30, context)),
                            child: CircularProgressIndicator(
                              color: $styles.colors.blue,
                            ),
                          )),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                              child: Padding(
                            padding: EdgeInsets.all(sizing(40, context)),
                            child: CustomText("No Result Found"),
                          ))),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _refresh() {
    if(widget.searchType == SearchTypes.place) {
      _placesPagingController.refresh();
    } else {
      _photographerPagingController.refresh();
    }
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
              newItems, _page++);
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
      _placesPagingController.error = event?.message;
    }
  }

  _addToWishlistPlace(PlaceModel model) {
    $objectBox.addWishlist(Wishlist(
        title: model.placeName,
        subTitle: model.state,
        type: UserRole.PLACE.name,
        image: model.featuredImage,
        objectId: "place_${model.id}",
        date: DateTime.now(),
        data: jsonEncode(model.toJson())));
  }

  _removeFromWishlistPlace(PlaceModel model) {
    $objectBox.deleteByObjectId("place_${model.id}");
  }

  _addToWishlistPhotographer(PhotographerDto model, type) {
    $objectBox.addWishlist(Wishlist(
        title: model.firmName,
        subTitle: model.placeName,
        type: type,
        image: model.featuredImage,
        objectId: type + "_" + model.id.toString(),
        date: DateTime.now(),
        data: jsonEncode(model.toJson())));
  }

  _removeFromWishlistPhotographer(PhotographerDto model, type) {
    $objectBox.deleteByObjectId(type + "_" + model.id.toString());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _placesPagingController.dispose();
    _photographerPagingController.dispose();
    super.dispose();
  }
}
