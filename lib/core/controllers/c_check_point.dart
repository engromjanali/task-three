import 'package:task_three/core/functions/f_call_back.dart';
import 'package:task_three/core/functions/f_printer.dart';
import 'package:task_three/s_home.dart';
import '/./core/services/navigation_service.dart';

// /// 🔁 A checkpoint to handle initialization and navigation after a short delay.
// class CCheckPoint {
//   Future<void> initialization() async {
//     printer("- a");
//     callBackFunction(() async {
//       printer("a");
//       await Future.delayed(const Duration(milliseconds: 500));
//       final context = NavigationService.currentContext;
//       if (!context.mounted) return;
//       final Brightness brightness = MediaQuery.of(context).platformBrightness;
//       final bool isDarkMode = brightness == Brightness.dark;
//       int? themeIndex = await SharedPrefService.instance.getInt(
//         PKeys.themeIndex,
//       );
//       final CTheme cTheme = PowerVault.find<CTheme>();
//       cTheme.updateTheme(index: themeIndex ?? (isDarkMode ? 1 : 0));
//       final CProfile cProfile = PowerVault.put(
//         CProfile(ProfileRepositoryImpl(ProfileDataSourceImpl())),
//       );
//       String? token = await SharedPrefService.instance.getString(
//         PKeys.usertoken,
//       );
//       // in here we are going ahed even user dose not signed.
//       if (!isNull(token)) {
//         await cProfile.getPatientList();
//       }
//       printer("b");
//       await const SHome().pushAndRemoveUntil();
//     });
//   }

// only for this project

class CCheckPoint {
  Future<void> initialization() async {
    printer("- a");
    callBackFunction(() async {
      printer("a");
      await Future.delayed(const Duration(milliseconds: 500));
      final context = NavigationService.currentContext;
      if (!context.mounted) return;
      await const SHome().pushAndRemoveUntil();
    });
  }
}
