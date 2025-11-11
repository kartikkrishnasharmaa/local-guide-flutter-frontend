import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/models/response/user_data.dart';
import 'package:localguider/network/network_const.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/admin/users/row_user.dart';
import 'package:localguider/ui/authentication/user_information.dart';

import '../../../common_libs.dart';
import '../../../components/custom_ink_well.dart';
import '../../../components/custom_text.dart';
import '../../../components/input_field.dart';
import '../../../main.dart';
import '../../../responsive.dart';
import '../../../utils/time_utils.dart';



class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends BaseState<UsersList, AdminBloc> {

  final TextEditingController _searchController = TextEditingController();

  final int _pageSize = 10;
  int _page = 1;

  String lastSearchText = "";

  final PagingController<int, UserData> _usersPagingController =
      PagingController(firstPageKey: 1);

  @override
  void init() {
    disableDialogLoading = true;
    _usersPagingController.addPageRequestListener((pageKey) {
      _page = pageKey;
      bloc.usersList(pageKey, _searchController.text.toString(), (p0) {
        _handleResponse(p0);
      });
    });
  }

  @override
  void postFrame() {
    _searchController.addListener(() {
      if(_searchController.text == lastSearchText) {
        return;
      }
      lastSearchText = _searchController.text;
      _usersPagingController.refresh();
    });
    super.postFrame();
  }

  @override
  AdminBloc setBloc() => AdminBloc();

  @override
  Widget view() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $styles.colors.secondarySurface,
        automaticallyImplyLeading: false,
        toolbarHeight: sizing(80, context),
        title: InputField(
            bgColor: $styles.colors.white,
            focusStrokeColor: $styles.colors.white,
            enabledStrokeColor: $styles.colors.white,
            iconEnd: CustomInkWell(
                onTap: () {
                  _downloadUsers();
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
            hint: "Search User",
            controller: _searchController),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
              () => _usersPagingController.refresh(),
        ),
        child: PagedListView<int, UserData>(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          pagingController: _usersPagingController,
          builderDelegate: PagedChildBuilderDelegate<UserData>(
              itemBuilder: (context, item, index) =>
                  RowUser(userData: item, onClick: () {
                    navigate(UserInformation(phone: "", password: "", userData: item, isAdmin: true, onUpdate: (user) {
                      _usersPagingController.refresh();
                    },));
                  }, onDelete: (user) {
                    _showDeleteUserConfirmation(user);
                  },),
              firstPageProgressIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(sizing(30, context)),
                        child: CircularProgressIndicator(
                                          color: $styles.colors.blue,
                                        ),
                      )),
              firstPageErrorIndicatorBuilder: (context) =>
                  Center(child: CustomText("No Result Found"))),
        ),
      ),
    );
  }

  _showDeleteUserConfirmation(UserData user) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          padding: EdgeInsets.all(sizing(15, context)),
          title: "Delete User?",
          dialogBackgroundColor: $styles.colors.background,
          titleTextStyle: TextStyle(
            color: $styles.colors.title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          descTextStyle: TextStyle(
            color: $styles.colors.title,
          ),
          desc: "Are you sure you want to delete this user?",
          btnCancelText: "Not Now",
          btnOkText: "Yes",
          btnOkOnPress: () {
            disableDialogLoading = false;
            bloc.deleteUser(user.id.toString(), (p0) {
              disableDialogLoading = true;
              if(p0.success == true) {
                _usersPagingController.refresh();
              } else {
                snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
              }
            });
          },
          btnCancelOnPress: () {})
          .show();
  }

  void _downloadUsers() {
    disableDialogLoading = false;
    bloc.download(EndPoints.DOWNLOAD_USERS, (p0) async {
      if(p0.success == true && p0.data != null) {
        bloc.showLoading();
        $fileUtils.saveBase64ToExcel(p0.data!, "Users_List_${TimeUtils.currentDate()}", () {
          bloc.dismissLoading();
          disableDialogLoading = true;
        });
      } else {
        snackBar("Failed!", p0.message ?? $strings.SOME_THING_WENT_WRONG);
      }
    });
  }

  _handleResponse(event) {
    if (event?.success == true) {
      try {
        final newItems = event?.data ?? [];
        final isLastPage = (newItems.length) < _pageSize;
        if (isLastPage) {
          _usersPagingController.appendLastPage(newItems);
        } else {
          _page++;
          _usersPagingController.appendPage(
              newItems, _page);
        }
      } catch (error) {
        _usersPagingController.error = error;
      }
    } else {
      _usersPagingController.error = event?.message;
    }
  }

}
