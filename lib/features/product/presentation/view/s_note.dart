import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';
import 'package:task_three/core/constants/all_enums.dart';
import 'package:task_three/core/extensions/ex_build_context.dart';
import 'package:task_three/core/extensions/ex_expanded.dart';
import 'package:task_three/core/extensions/ex_padding.dart';
import 'package:task_three/core/functions/f_call_back.dart';
import 'package:task_three/core/functions/f_printer.dart';
import 'package:task_three/core/services/navigation_service.dart';
import 'package:task_three/core/widgets/drop_down/w_drop_down.dart';
import 'package:task_three/core/widgets/load_and_error/models/view_state_model.dart';
import 'package:task_three/core/widgets/w_app_shimmer.dart';
import 'package:task_three/core/widgets/w_dialog.dart';
import 'package:task_three/core/widgets/w_text_field.dart';
import 'package:task_three/features/product/data/datasource/note_datasource_impl.dart';
import 'package:task_three/features/product/data/model/m_filter.dart';
import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/data/repository/note_repository_impl.dart';
import 'package:task_three/features/product/presentation/controller/c_note.dart';
import 'package:task_three/features/product/presentation/view/s_add.dart';
import 'package:task_three/features/product/presentation/view/s_details.dart';
import 'package:task_three/features/product/presentation/widget/w_listtile.dart';

class SNote extends StatefulWidget {
  const SNote({super.key});

  @override
  State<SNote> createState() => _SNoteState();
}

class _SNoteState extends State<SNote> {
  List<MNote> items = [];
  CNote cNote = PowerVault.put(CNote(NoteRepositoryImpl(NoteDataSourceImpl())));
  ValueNotifier<MFilter> filterNotifyer = ValueNotifier(MFilter());
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callBackFunction(() {
      cNote.fetchNote().then((products) {
        items.addAll(products ?? []);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: PowerBuilder<CNote>(
        builder: (cNote) {
          return ValueListenableBuilder(
            valueListenable: filterNotifyer,
            builder: (context, filter, child) {
              printer("rebuild notifyer");
              items = filterItemList(cNote.noteList, filter);
              if (cNote.viewState == ViewState.loading && items.isEmpty) {
                return ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
                );
              }
              return Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (val) {
                      filterNotifyer.value = MFilter(title: val);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_sharp),
                      hintText: "Search Note Here",
                      suffixIcon: IconButton(
                        onPressed: () async {},
                        icon: Icon(Icons.tune_rounded),
                      ),
                    ),
                  ).pB(),

                  RefreshIndicator(
                    onRefresh: () async {
                      printer("refreshed");
                      cNote.noteList.clear();
                      cNote.update();
                      await cNote.fetchNote();
                    },
                    color: context.textTheme?.titleMedium?.color,
                    backgroundColor: context.fillColor,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        MNote mNote = items[index];
                        return WListTile(
                          title: mNote.title,
                          subTitle: mNote.body,
                          onTap: () {
                            SDetails(mNote: mNote).push();
                          },
                          onAction: (ActionType p1) {
                            if (p1 == ActionType.edit) {
                              SAdd(isEditPage: true, mNote: mNote).push();
                            } else if (p1 == ActionType.delete) {
                              cNote.deleteNote(mNote.id!);
                            }
                          },
                        );
                      },
                    ),
                  ).expd(),
                ],
              ).pAll();
            },
          );
        },
      ),
    );
  }
}

List<MNote> filterItemList(List<MNote> input, MFilter mFilter) {
  List<MNote> res;

  res = input
      .where(
        (o) => (o.title ?? "").toLowerCase().contains(
          mFilter.title ?? "".toLowerCase(),
        ),
      )
      .toList();
  return res;
}
