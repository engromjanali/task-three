import 'package:task_three/core/data/local/local_cache_service.dart';
import 'package:task_three/core/functions/f_printer.dart';
import 'package:task_three/features/product/data/datasource/note_datasource_impl.dart';
import 'package:task_three/features/product/data/model/m_note.dart';

class SyncService {
  final LocalCacheService _cacheService = LocalCacheService();
  SyncService._();
  static SyncService instance = SyncService._();
  factory SyncService() => instance;
  bool _isSyncing = false;

  Future<void> initSync() async {
    if (_isSyncing) {
      // prevent duplicate call
      printer("Prevented duplicate call");
      return;
    }
    // set sync flag
    _isSyncing = true;
    // --------go ahed--------
    late bool flag;
    // at first synce all delete request
    flag = await syncDelete();
    // then save all add request
    if (flag) {
      flag = await syncAdd();
    }
    // now synce all update request
    if (flag) {
      flag = await syncUpdate();
    }
    //-------- all done reset sync flag--------
    _isSyncing = false;
  }

  Future<bool> syncDelete() async {
    printer("called syncDelete");
    // get all pending delete request
    List<Map<String, dynamic>> data = await _cacheService.getDeleteList();
    for (Map<String, dynamic> json in data) {
      MNote mNote = MNote.fromJson(json);
      // remove from cache because if it's fail again autometically will be added again.
      // and for success allright.
      await _cacheService.removeById(LocalCacheService.keyDelete, mNote.id!);
      try {
        await NoteDataSourceImpl().deteteNote(mNote.id!);
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  /// sync pending add requests
  Future<bool> syncAdd() async {
    printer("called syncAdd");
    // get all pending add request
    List<Map<String, dynamic>> data = await _cacheService.getAddList();
    // printer("add length : ${data.length}");
    for (Map<String, dynamic> json in data) {
      MNote mNote = MNote.fromJson(json);
      // remove from cache because if it's fail again autometically will be added again.
      // and for success allright.
      await _cacheService.removeById(LocalCacheService.keyAdd, mNote.id!);
      try {
        await NoteDataSourceImpl().addNote(mNote);
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  /// sync update pending requests
  Future<bool> syncUpdate() async {
    printer("called syncUpdate");
    // get all pending update request
    List<Map<String, dynamic>> data = await _cacheService.getUpdateList();
    for (Map<String, dynamic> json in data) {
      MNote mNote = MNote.fromJson(json);
      // remove from cache because if it's fail again autometically will be added again.
      // and for success allright.
      await _cacheService.removeById(LocalCacheService.keyUpdate, mNote.id!);
      try {
        await NoteDataSourceImpl().updateNote(mNote);
      } catch (e) {
        return false;
      }
    }
    return true;
  }
}
