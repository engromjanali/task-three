import 'package:flutter/material.dart';
import 'package:task_three/core/constants/default_values.dart';
import 'package:task_three/core/extensions/ex_build_context.dart';
import 'package:task_three/core/extensions/ex_date_time.dart';
import 'package:task_three/core/extensions/ex_padding.dart';
import 'package:task_three/core/extensions/ex_strings.dart';
import 'package:task_three/core/functions/f_is_null.dart';
import 'package:task_three/core/services/navigation_service.dart';
import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/presentation/view/s_add.dart';

class SDetails extends StatefulWidget {
  final bool isTask;
  final bool? isFromVault;
  final MNote? mNote;
  const SDetails({
    super.key,
    this.isTask = false,
    this.mNote,
    this.isFromVault,
  });
  @override
  State<SDetails> createState() => _SDetailsState();
}

class _SDetailsState extends State<SDetails> {
  final ValueNotifier<Duration?> targetedDurationListener =
      ValueNotifier<Duration?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTask ? "Task" : "Note"),
        actions: [
          IconButton(
            onPressed: () {
              SAdd(isEditPage: true, mNote: widget.mNote,).pushReplacement();
              
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.mNote?.title ?? "").toTitleCase.showDVIE,
                    style: context.textTheme?.titleSmall,
                  ),
                ],
              ).pDivider().pB(),
              // details section
              Text(
                widget.mNote?.body ?? PDefaultValues.noName,
                textAlign: TextAlign.justify,
                style: context.textTheme?.bodyLarge,
              ).pB(),
              // info section
              SizedBox.shrink().pDivider(),
              // remaining time
              showDateAsFormated(
                "Created At",
                null, //date
                doNotShowIfNull: false,
                context: context,
              ),
            ],
          ).pAll(),
        ),
      ),
    );
  }
}

Widget showDateAsFormated(
  String leading,
  DateTime? dateTime, {
  bool doNotShowIfNull = true,
  Color? color,
  required BuildContext context,
}) {
  if (doNotShowIfNull) {
    return isNotNull(dateTime)
        ? Text(
            "$leading: ${dateTime?.format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA)}",
            style: context.textTheme?.bodyMedium?.copyWith(color: color),
          )
        : SizedBox.shrink();
  } else {
    return Text(
      "$leading: ${dateTime?.format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA) ?? PDefaultValues.noName}",
      style: context.textTheme?.bodyMedium?.copyWith(color: color),
    );
  }
}
