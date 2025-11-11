
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../../components/custom_text.dart';
import '../../main.dart';
import '../../responsive.dart';
import '../models/selection_model.dart';
import '../style/colors.dart';

class ItemSelectionSheet extends StatefulWidget {
  List<SelectionModel> list = [];
  String title;
  SelectionModel? selectedItem;

  Function(SelectionModel? country)? onItemSelected;

  ItemSelectionSheet(
      {super.key,
      required this.title,
      required this.list,
      this.selectedItem,
      this.onItemSelected});

  @override
  State<ItemSelectionSheet> createState() => _ItemSelectionSheetState();
}

class _ItemSelectionSheetState extends State<ItemSelectionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: $styles.colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(sizing(10, context)),
            topLeft: Radius.circular(sizing(10, context))),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: sizing(10, context),
        right: sizing(10, context),
        top: sizing(10, context),
      ),
      child: Column(
        children: [
          SizedBox(
            height: sizing(5, context),
          ),
          Center(
            child: Container(
              width: sizing(35, context),
              height: sizing(5, context),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(sizing(10, context)),
              ),
            ),
          ),
          SizedBox(
            height: sizing(15, context),
          ),
          CustomText(
            widget.title,
            color: $styles.colors.title,
          ),
          SizedBox(
            height: sizing(15, context),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return selectionItemRow(
                    widget.list[index],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget selectionItemRow(SelectionModel item) {
    bool isSelected = item == widget.selectedItem;

    return Material(
      color: colorTransparent,
      child: InkWell(
        onTap: () {
          widget.onItemSelected!(item);
          navigatePop(context);
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(sizing(10, context)),
              child: Row(
                children: [
                  CustomText(
                    item.title ?? "",
                    fontSize: sizing(15, context),
                    color: isSelected
                        ? $styles.colors.blue
                        : $styles.colors.whiteGreyText,
                  ),
                  const Spacer(),
                  if (item.icon != null)
                    Icon(
                      item.icon,
                      color: isSelected
                          ? $styles.colors.blue
                          : $styles.colors.whiteGreyText,
                    )
                ],
              ),
            ),
            Divider(
              height: sizing(1, context),
              color: $styles.colors.greyMedium,
              thickness: 0.2,
            )
          ],
        ),
      ),
    );
  }

}
