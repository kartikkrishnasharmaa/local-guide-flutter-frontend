import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localguider/base/base_state.dart';
import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/ui/admin/admin_settings.dart';
import 'package:localguider/ui/admin/content_list.dart';
import 'package:localguider/ui/admin/dashboard/row_button.dart';
import 'package:localguider/ui/admin/network/admin_bloc.dart';
import 'package:localguider/ui/admin/notificaion/send_notification.dart';
import 'package:localguider/ui/admin/users/users_list.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/ui/settings/notifications.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/values/assets.dart';

import '../../../common_libs.dart';
import '../../../models/response/admin_dashboard_dto.dart';
import '../../../responsive.dart';
import '../../payments/transactions.dart';
import '../../payments/withdrawals.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends BaseState<AdminDashboard, AdminBloc> {

  AdminDashboardDto? adminDashboardDto;

  @override
  void init() {
  }
  @override
  void postFrame() {
    super.postFrame();
    bloc.adminDashboard((p0) {
      setState(() {
        adminDashboardDto = p0.data;
      });
    });
  }

  @override
  AdminBloc setBloc() => AdminBloc();

  @override
  Widget view() {
    return Scaffold(
      backgroundColor: $styles.colors.blueBg,
      appBar: AppBar(
        backgroundColor: $styles.colors.blue,
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText("Admin", color: $styles.colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StaggeredGrid.count(
              crossAxisCount: isMobView(context)
                  ? 2
                  : isTablet(context)
                  ? 4
                  : isDesktop(context)
                  ? 6
                  : 2,
              children: [
                RowButton(
                  image: Images.icUsers,
                  title: "Users",
                  subtitle: adminDashboardDto?.totalUsers.toString() ?? "0",
                  onClick: () {
                    navigate(const UsersList());
                  },
                ),
                RowButton(
                  image: Images.icPhotographersHome,
                  title: "Photographers",
                  subtitle: adminDashboardDto?.totalPhotographers.toString() ?? "0",
                  onClick: () {
                    navigate(ContentList(searchType: SearchTypes.photographer));
                  },
                ),
                RowButton(
                  image: Images.icGuiderHome,
                  title: "Guiders",
                  subtitle: adminDashboardDto?.totalGuiders.toString() ?? "0",
                  onClick: () {
                    navigate(ContentList(searchType: SearchTypes.guider));
                  },
                ),
                RowButton(
                  image: Images.icPlace,
                  title: "Places",
                  subtitle: adminDashboardDto?.totalPlaces.toString() ?? "0",
                  onClick: () {
                    navigate(ContentList(searchType: SearchTypes.place));
                  },
                ),
                RowButton(
                  image: Images.icCashWithdrawal,
                  title: "Withdrawals",
                  subtitle: adminDashboardDto?.pendingWithdrawals.toString() ?? "0",
                  onClick: () {
                    navigate(Withdrawals(userRole: UserRole.ADMIN, dto: null,));
                  },
                ),
                RowButton(
                  image: Images.icTransactions,
                  title: "Transactions",
                  subtitle: adminDashboardDto?.totalTransactions.toString() ?? "0",
                  onClick: () {
                    navigate(Transactions(userRole: UserRole.ADMIN,));
                  },
                ),
                RowButton(
                  image: Images.icAccountSetting_64,
                  title: "Settings",
                  subtitle: "",
                  onClick: () {
                    navigate(const AdminSettings());
                  },
                ),
                RowButton(
                  image: Images.icNotification,
                  title: "Notifications",
                  subtitle: "",
                  onClick: () {
                    navigate(Notifications(userRole: UserRole.ADMIN, dtoId: "", refreshCallback: () {},));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
