import 'dart:io';

import 'package:localguider/components/app_image.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:localguider/utils/extensions.dart';

import '../../common_libs.dart';
import '../../components/custom_text.dart';
import '../../models/response/service_dto.dart';
import '../../style/styles.dart';

class RowServicesNPlans extends StatefulWidget {
  ServiceDto service;
  bool isSelectionOnly = false;
  Function(bool edit, bool delete) onResponse;

  RowServicesNPlans(
      {super.key, required this.service, this.isSelectionOnly = false, required this.onResponse});

  @override
  State<RowServicesNPlans> createState() => _RowServicesNPlansState();
}

class _RowServicesNPlansState extends State<RowServicesNPlans> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizing(10, context)),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(sizing(15, context)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sizing(15, context)),
            border: Border.all(color: $styles.colors.blue, width: 1)),
        child: Row(
          children: [
            SizedBox(
              width: sizing(60, context),
              height: sizing(60, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.isSelectionOnly && widget.service.image != null ? Image.file(
                  File(widget.service.image!),
                  fit: BoxFit.fill,
                ) : AppImage(
                    image: NetworkImage(widget.service.image.appendRootUrl()), fit: BoxFit.cover,),
              ),
            ),
            gap(context, width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    widget.service.title ?? "",
                    fontSize: sizing(16, context),
                    maxLines: 1,
                    color: $styles.colors.blue,
                    style: FontStyles.medium,
                  ),
                  CustomText(
                      "Price: ₹${widget.service.servicePrice?.toStringAsFixed(2)}",
                      color: $styles.colors.greyMedium,
                      fontSize: sizing(13, context),
                      maxLines: 1),
                  if (widget.service.description != null)
                    CustomText(widget.service.description ?? "",
                        fontSize: sizing(13, context), maxLines: 2),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.onResponse(true, false);
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: $styles.colors.blue,
                    )),
                IconButton(
                    onPressed: () {
                      widget.onResponse(false, true);
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: $styles.colors.red,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
