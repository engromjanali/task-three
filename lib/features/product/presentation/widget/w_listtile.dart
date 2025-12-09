import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_three/core/constants/all_enums.dart';
import 'package:task_three/core/constants/colors.dart';
import 'package:task_three/core/constants/default_values.dart';
import 'package:task_three/core/constants/dimension_theme.dart';
import 'package:task_three/core/extensions/ex_build_context.dart';
import 'package:task_three/core/extensions/ex_expanded.dart';
import 'package:task_three/core/extensions/ex_padding.dart';
import 'package:task_three/core/extensions/ex_strings.dart';
import 'package:task_three/core/widgets/w_container.dart';

class WListTile extends StatelessWidget {
  final Color? leadingColor;
  final Color? fillColor;
  final String? title;
  final String? subTitle;
  final Function() onTap;
  final Function(ActionType) onAction;
  final bool isFromVault;
  final bool isSecretNote;
  const WListTile({
    super.key,
    this.leadingColor,
    this.fillColor,
    this.title,
    this.subTitle,
    required this.onTap,
    required this.onAction,
    this.isFromVault = false,
    this.isSecretNote = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        _showPopupMenu(
          context,
          isFromVault: isFromVault,
          isSecretNote: isSecretNote,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PTheme.borderRadius),
        child: Container(
          decoration: BoxDecoration(color: fillColor ?? context.cardColor),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  color: leadingColor ?? PColors.completedColor,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (title ?? "").toTitleCase.showDVIE,
                        style: context.textTheme?.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: PTheme.spaceX,
                        children: [
                          Icon(
                            Icons.subdirectory_arrow_right_outlined,
                            size: context.textTheme?.titleSmall?.fontSize,
                          ),
                          Text(
                            subTitle ?? PDefaultValues.noName,
                            style: context.textTheme?.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ).expd(),
                        ],
                      ),
                    ],
                  ).pAll(),
                ),
              ],
            ),
          ),
        ),
      ).pV(value: 5),
    );
  }

  void _showPopupMenu(
    BuildContext context, {
    required bool isFromVault,
    required bool isSecretNote,
  }) {
    final RenderBox renderBox =
        context.findRenderObject() as RenderBox; // get parent/tile's position.
    final Offset offset = renderBox.localToGlobal(
      Offset.zero,
    ); // get the parent/tile's top-left corner.

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + renderBox.size.width, // Position from right
        offset.dy + renderBox.size.height / 2, // Center vertically
        offset.dx + renderBox.size.width, // Right edge
        offset.dy + renderBox.size.height, // Bottom edge
      ),

      color: Colors.transparent,
      elevation: 0,

      items: [
        PopupMenuItem(
          onTap: () {
            onAction(ActionType.edit);
          },
          value: 'edit',
          padding: EdgeInsets.symmetric(vertical: 2),
          child: WContainer(
            verticalPadding: 10,
            borderInDark: true,
            child: Center(
              child: Row(
                spacing: PTheme.spaceX,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.edit, size: 20.w, color: Color(0xFF0088FF)),
                  Text('Edit', textAlign: TextAlign.center).expd(),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            onAction(ActionType.delete);
          },
          padding: EdgeInsets.symmetric(vertical: 2),
          value: 'Delete',
          child: WContainer(
            verticalPadding: 10,
            color: Colors.red,
            // borderInDark: true,
            child: Center(
              child: Row(
                spacing: PTheme.spaceX,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, size: 20.w, color: Colors.black),
                  Text('Delete', textAlign: TextAlign.center).expd(),
                ],
              ),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // done some opration here.
      }
    });
  }
}
