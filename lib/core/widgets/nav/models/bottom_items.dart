import 'package:task_three/features/product/presentation/view/s_add.dart';
import 'package:task_three/features/product/presentation/view/s_note.dart';
import 'package:task_three/gen/assets.gen.dart';
import 'm_nav_bar_item.dart';

List<MNavBarItem> homeNevItem = [
  MNavBarItem(
    title: "Note",
    unSelectedIcon: Assets.icons.taskChecklist,
    icon: Assets.icons.taskChecklist,
    child: SNote(),
  ),
  MNavBarItem(
    title: "Add",
    unSelectedIcon: Assets.icons.add,
    icon: Assets.icons.add,
    child: SAdd(),
  ),
  MNavBarItem(
    title: "Profile",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SNote(),
  ),
];
