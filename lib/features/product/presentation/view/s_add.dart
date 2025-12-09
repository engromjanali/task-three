import 'dart:async';
import 'package:task_three/core/extensions/ex_date_time.dart';
import 'package:task_three/core/extensions/ex_keyboards.dart';
import 'package:task_three/core/extensions/ex_padding.dart';
import 'package:task_three/core/functions/f_call_back.dart';
import 'package:task_three/core/functions/f_snackbar.dart';
import 'package:task_three/core/services/navigation_service.dart';
import 'package:task_three/core/widgets/w_button.dart';
import 'package:task_three/core/widgets/w_text_field.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';
import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/presentation/controller/c_note.dart';

class SAdd extends StatefulWidget {
  final bool isEditPage;
  final MNote? mNote;

  const SAdd({super.key, this.isEditPage = false, this.mNote});

  @override
  State<SAdd> createState() => _SAddState();
}

class _SAddState extends State<SAdd> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  CNote cNote = PowerVault.find<CNote>();

  final double spacing = 20;

  @override
  void initState() {
    super.initState();
    callBackFunction(() {
      if (widget.isEditPage) {
        titleController.text = widget.mNote?.title ?? "";
        detailsController.text = widget.mNote?.body ?? "";
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    context.unFocus();
    if (fromKey.currentState?.validate() ?? false) {
      // normal datetime or DateTime.now() dose not contain utc it's only contain date and time.
      // final now = DateTime.now().toUtc();// way 1
      final now = DateTime.timestamp(); // way 2

      MNote payload = MNote(
        id: (widget.isEditPage
            ? widget.mNote?.id!
            : int.parse(DateTime.timestamp().timestamp)),
        title: titleController.text.trim(),
        body: detailsController.text.trim(),
      );
      if (widget.isEditPage) {
        await cNote.updateNote(payload);
      } else {
        await cNote.addNote(payload);
      }
      // ALL DONE NOW DELETE THEME.
      titleController.text = "";
      detailsController.text = "";
      if (widget.isEditPage) {
        Navigation.pop();
        showSnackBar("Updated!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditPage ? "Update Note" : "Add Note"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            spacing: spacing,
            children: [
              Form(
                key: fromKey,
                child: Column(
                  spacing: spacing,
                  children: [
                    WTextField.requiredField(
                      label: "Title",
                      controller: titleController,
                    ),
                    WTextField.requiredField(
                      label: "Details",
                      controller: detailsController,
                      maxLines: 20,
                      minLines: 4,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Invalid Details";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.newline,
                    ),
                  ],
                ),
              ),

              PowerBuilder<CNote>(
                builder: (cNote) => WPrimaryButton(
                  text: "Submit",
                  onTap: submit,
                  isLoading: cNote.isLoadingMore,
                ),
              ),
            ],
          ).pAll(),
        ),
      ),
    );
  }
}
