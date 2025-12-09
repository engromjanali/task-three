import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_three/core/extensions/ex_build_context.dart';
import 'package:task_three/core/extensions/ex_padding.dart';

class WRattingTile extends StatelessWidget {
  final double ratting;
  final int? totolReview;
  final double? size;
  final int outOf;
  final double? spacing;
  final bool onlyRatting;
  final Function(int)? onTap;
  const WRattingTile({
    super.key,
    required this.ratting,
    this.outOf = 5,
    this.size,
    this.spacing,
    this.onlyRatting = false,
    this.totolReview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Row(
              children: [
                ...List.generate(
                  ratting.floor(),
                  (index) => GestureDetector(
                    onTap: () {
                      onTap?.call(index + 1);
                    },
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: size ?? 20.w,
                    ),
                  ),
                ),
                if ((ratting) % 1 != 0)
                  Icon(
                    Icons.star_half_outlined,
                    color: Colors.amber,
                    size: size ?? 20.w,
                  ),
                ...List.generate(
                  outOf - (ratting.ceil()),
                  (index) => GestureDetector(
                    onTap: () {
                      onTap?.call((index + 1) + ratting.toInt());
                    },
                    child: Icon(
                      Icons.star,
                      color: context.primaryTextColor,
                      size: size ?? 20.w,
                    ),
                  ),
                ),
              ],
            ).pR(),
            if (!onlyRatting)
              Row(
                children: [
                  Text(
                    ratting.toString(),
                    style: context.textTheme?.bodyMedium,
                  ).pR(),
                  Text(
                    " (${totolReview ?? 0}) Reviews",
                    style: context.textTheme?.bodyMedium,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
