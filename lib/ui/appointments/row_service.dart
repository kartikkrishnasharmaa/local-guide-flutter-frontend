import 'package:localguider/components/custom_ink_well.dart';
import 'package:localguider/components/profile_view.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/style/styles.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../models/response/service_dto.dart';

class RowService extends StatefulWidget {
  ServiceDto service;
  bool isSelected = false;
  Function onClick;
  RowService({super.key, required this.service, required this.isSelected, required this.onClick});

  @override
  State<RowService> createState() => _RowServiceState();
}

class _RowServiceState extends State<RowService> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizing(10, context)),
      child: InkWell(
        onTap: () {
          widget.onClick();
        },
        child: Container(
          width: sizing(120, context),
          height: sizing(120, context),
          decoration: BoxDecoration(
            color: $styles.colors.blueSurface,
            borderRadius: BorderRadius.circular(20),
            border: widget.isSelected ? Border.all(color: $styles.colors.red, width: 1.5) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: sizing(50, context),
                height: sizing(50, context),
                decoration: BoxDecoration(
                    color: $styles.colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(sizing(10, context)),
                        topLeft: Radius.circular(sizing(20, context)))),
                child: Center(
                    child: ProfileView(
                        diameter: 40,
                        profileUrl: widget.service.image.appendRootUrl())),
              ),
              gap(context, height: 5),
              Padding(
                padding: EdgeInsets.all(sizing(7, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "${widget.service.servicePrice?.toStringAsFixed(2) ?? "0.0"} ₹",
                      fontSize: 12,
                      maxLines: 1,
                      style: FontStyles.light,
                    ),
                    gap(context, height: 5),
                    CustomText(
                      widget.service.title ?? "",
                      fontSize: 12,
                      maxLines: 1,
                      style: FontStyles.light,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
