import 'package:localguider/components/app_image.dart';
import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/ui/authentication/edit_profile.dart';
import 'package:localguider/ui/dashboard/appointment_requests.dart';
import 'package:localguider/ui/dashboard/appointment_requests_main_page.dart';
import 'package:localguider/ui/dashboard/appointment_status.dart';
import 'package:localguider/ui/dashboard/dashboard.dart';
import 'package:localguider/ui/join/join_request_status.dart';
import 'package:localguider/ui/join/join_us.dart';
import 'package:localguider/ui/privacy/simple_text_viewer.dart';
import 'package:localguider/ui/search/search_content.dart';
import 'package:localguider/ui/search/search_types.dart';
import 'package:localguider/ui/wishlist/wishlist_page.dart';
import 'package:localguider/user_role.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../../values/assets.dart';
import '../authentication/user_information.dart';
import '../payments/add_payment.dart';
import '../payments/transactions.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: $styles.colors.white,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: sizing(250, context),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      sizing($appUtils.defaultCornerRadius, context)),
                  bottomRight: Radius.circular(
                      sizing($appUtils.defaultCornerRadius, context))),
              child: Stack(
                children: [
                  Container(
                    height: sizing(250, context),
                    decoration: BoxDecoration(
                      color: $styles.colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              sizing($appUtils.defaultCornerRadius, context)),
                          bottomRight: Radius.circular(
                              sizing($appUtils.defaultCornerRadius, context))),
                    ),
                  ),
                  Positioned(
                    right: -sizing(300, context),
                    top: -sizing(150, context),
                    bottom: -10,
                    left: sizing(180, context),
                    child: Container(
                      height: sizing(250, context),
                      width: sizing(250, context),
                      decoration: BoxDecoration(
                          color: $styles.colors.blue2,
                          borderRadius:
                              BorderRadius.circular(sizing(250, context))),
                    ),
                  ),
                  Positioned(
                    right: -sizing(450, context),
                    top: -sizing(150, context),
                    bottom: -50,
                    left: sizing(250, context),
                    child: Container(
                      height: sizing(250, context),
                      width: sizing(250, context),
                      decoration: BoxDecoration(
                          color: $styles.colors.blue3,
                          borderRadius:
                              BorderRadius.circular(sizing(250, context))),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: double.maxFinite,
                                child: Center(
                                  child: CustomText($strings.profile,
                                      style: FontStyles.medium,
                                      color: $styles.colors.white),
                                )),
                            IconButton(
                                onPressed: () {
                                  navigatePop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: $styles.colors.white,
                                )),
                          ],
                        ),
                      ),
                      gap(context, height: 10),
                      CustomInkWell(
                        onTap: () {
                          navigate(UserInformation(
                            phone: "",
                            password: "",
                            userData: $user.getUser(),
                            isEditProfile: true,
                            onUpdate: (user) {
                              $user.saveDetails(user);
                            },
                          ));
                        },
                        child: ProfileView(
                            diameter: 60,
                            outerStrokeColor: $styles.colors.white,
                            outerStrokeWidth: 2,
                            innerStrokeWidth: 0,
                            strokeGap: 0,
                            profileUrl:
                                $user.getUser()!.profile.appendRootUrl()),
                      ),
                      gap(context, height: 5),
                      CustomText(
                        $user.getUser()?.name ?? "",
                        color: $styles.colors.white,
                        style: FontStyles.medium,
                      ),
                      if ($user.getUser()?.email != null)
                        CustomText(
                          $user.getUser()?.email ?? "",
                          color: $styles.colors.greyLight,
                        ),
                      CustomText(
                        "Balance: ₹ ${$user.getUser()?.balance?.toStringAsFixed(2) ?? 0.0}",
                        color: $styles.colors.greyLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          gap(context, height: 10),
          _drawerMenuView(Images.icHouse64, "Home", () {
            navigatePop(context);
          }),
          if ($user.getUser()?.photographer == true ||
              $user.getUser()?.guider == true)
            _drawerMenuView(Images.icDashboard, "Dashboard", () {
              navigate(const Dashboard());
            }),
          _drawerMenuView(Images.icBaselineCreditCard_60, "Add Balance", () {
            navigate(AddPayment(
              userId: $user.getUser()?.id.toString(),
              callback: (b, a) {
                if (b) {
                  setState(() {
                    $user.getUser()?.balance =
                        ($user.getUser()?.balance?.toDouble() ?? 0.0) + a;
                  });
                }
              },
            ));
          }, color: $styles.colors.green),
          _drawerMenuView(Images.icBaselineHistory_60, "Transaction History",
              () {
            navigate(Transactions(
              userRole: UserRole.JUST_USER,
            ));
          }, color: $styles.colors.blue),
          _drawerMenuView(
            Images.icBooking,
            "Appointments",
            () {
              navigate(AppointmentRequestsMainPage(
                role: UserRole.JUST_USER,
                dtoId: $user.getUser()?.id.toString(),
                initialStatus: AppointmentStatus.requested,
              ));
            },
          ),
          _drawerMenuView(Images.icRoundFavorite24, "Your Wishlist", () {
            navigate(const WishlistPage());
          }, color: $styles.colors.red),
          _drawerMenuView(Images.icDestination64, "Explore Place", () {
            navigate(SearchContent(searchType: SearchTypes.place));
          }),
          _drawerMenuView(Images.icTourismGuide64, "Find Tourist Guiders", () {
            navigate(SearchContent(searchType: SearchTypes.guider));
          }),
          _drawerMenuView(Images.icPhotographer64, "Find Photographers", () {
            navigate(SearchContent(searchType: SearchTypes.photographer));
          }),
          Padding(
            padding: EdgeInsets.only(
                left: sizing(15, context), right: sizing(15, context)),
            child: Divider(
              color: $styles.colors.greyMedium,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: sizing(15, context)),
            child: CustomText(
              "Other",
              style: FontStyles.medium,
              fontSize: sizing(10, context),
            ),
          ),
          if ($user.getUser()?.photographer != true &&
              $user.getUser()?.guider != true)
            _drawerMenuView(
              Images.icTraveler,
              "Work with us",
              () {
                if ($user.getUser()?.gid != null) {
                  navigate(JoinRequestStatus(
                    userRole: UserRole.GUIDER,
                    dtoId: $user.getUser()?.gid.toString() ?? "",
                  ));
                } else if ($user.getUser()?.pid != null) {
                  navigate(JoinRequestStatus(
                      userRole: UserRole.PHOTOGRAPHER,
                      dtoId: $user.getUser()?.pid.toString() ?? ""));
                } else {
                  _chooseUserRoleType();
                }
              },
            ),
          _drawerMenuView(
            Images.icTeam64,
            "About us",
            () {
              navigate(SimpleTextViewer(
                  title: "About Us",
                  content: $appUtils.getSettings()?.aboutUs ?? ""));
            },
          ),
          _drawerMenuView(
            Images.icContactUs,
            "Contact us",
            () {
              _contactUsDialog("Contact us");
            },
          ),
          _drawerMenuView(
            Images.icPrivacyPolicy64,
            "Privacy & Policy",
            () {
              navigate(SimpleTextViewer(
                  title: "Privacy & Policy",
                  content: $appUtils.getSettings()?.privacyPolicy ?? ""));
            },
          ),
          _drawerMenuView(
            Images.icTermsAndConditions64,
            "Terms & Conditions",
            () {
              navigate(SimpleTextViewer(
                  title: "Terms & Conditions",
                  content: $appUtils.getSettings()?.termsAndConditions ?? ""));
            },
          ),
          _drawerMenuView(
            Images.icHelp,
            "Help",
            () {
              $appUtils.openUrl("https://docs.google.com/forms/d/e/1FAIpQLSdnBiPZM-uvhNj6Q-hqkj0SdriQnuQmJbYo1NseZpEaRGIY3g/viewform?usp=header");
            },
          ),
          _drawerMenuView(
            Images.icLogOut64,
            "Log out",
            () {
              $appUtils.logOut(context);
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                left: sizing(15, context), right: sizing(15, context)),
            child: Divider(
              color: $styles.colors.greyMedium,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: sizing(15, context)),
            child: CustomText(
              "We are social",
              style: FontStyles.medium,
              fontSize: sizing(10, context),
            ),
          ),
          _drawerMenuView(
            Images.icWhatsapp64,
            "Whatsapp",
            () {
              $appUtils.openUrl(
                  "https://wa.me/91${$appUtils.getSettings()?.whatsAppNumber}");
            },
          ),
          _drawerMenuView(
            Images.icFacebook64,
            "Facebook",
            () {
              $appUtils.openUrl($appUtils.getSettings()?.facebook ?? "");
            },
          ),
          _drawerMenuView(
            Images.icTwitter64,
            "Twitter",
            () {
              $appUtils.openUrl($appUtils.getSettings()?.twitter ?? "");
            },
          ),
          _drawerMenuView(
            Images.icInstagram64,
            "Instagram",
            () {
              $appUtils.openUrl($appUtils.getSettings()?.instagram ?? "");
            },
          ),
          gap(context, height: 20)
        ],
      ),
    );
  }

  void _contactUsDialog(title) {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return AlertDialog(
            title: CustomText(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _drawerMenuView(
                  Images.icWhatsapp64,
                  "Whatsapp",
                  () {
                    $appUtils.openUrl(
                        "https://wa.me/91${$appUtils.getSettings()?.whatsAppNumber}");
                  },
                ),
                _drawerMenuView(
                  Images.icPhoneCall,
                  "Contact Now",
                  () {
                    $appUtils.openUrl(
                        "https://wa.me/91${$appUtils.getSettings()?.whatsAppNumber}");
                  },
                ),
              ],
            ),
          );
        });
  }

  _chooseUserRoleType() {
    navigatePop(context);
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              "Choose your role",
              fontSize: sizing(17, context),
              style: FontStyles.openSansRegular,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    title: CustomText("Photographer"),
                    leading: SizedBox(
                        height: sizing(20, context),
                        width: sizing(20, context),
                        child: AppImage(
                            image: AssetImage(Images.icPhotographersHome))),
                    onTap: () {
                      navigatePop(context);
                      navigate(JoinUs(userRole: UserRole.PHOTOGRAPHER));
                    }),
                ListTile(
                    title: CustomText("Guider"),
                    leading: SizedBox(
                        height: sizing(20, context),
                        width: sizing(20, context),
                        child:
                            AppImage(image: AssetImage(Images.icGuiderHome))),
                    onTap: () {
                      navigatePop(context);
                      navigate(JoinUs(userRole: UserRole.GUIDER));
                    }),
              ],
            ),
          );
        });
  }

  _drawerMenuView(image, title, Function() onClick, {color}) {
    return CustomInkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizing(10, context), horizontal: sizing(20, context)),
        child: Row(
          children: [
            SizedBox(
              height: sizing(20, context),
              width: sizing(20, context),
              child: Image.asset(
                image,
                color: color,
              ),
            ),
            gap(context, width: 10),
            CustomText(
              title,
              style: FontStyles.medium,
            )
          ],
        ),
      ),
      onTap: () {
        onClick();
      },
    );
  }
}
