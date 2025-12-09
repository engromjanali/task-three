import 'package:dio/dio.dart';
import 'package:task_three/core/data/local/local_cache_service.dart';
import 'package:task_three/core/services/dio_service.dart';
import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/domain/note_datasource.dart';

class NoteDataSourceImpl extends INoteDataSource {
  String path = "/posts";
  LocalCacheService localCacheService = LocalCacheService();

  @override
  Future<MNote> addNote(MNote payload) async {
    await localCacheService.saveAdd(payload.toJson());
    Response res = await makeRequest(
      path: path,
      method: HTTPMethod.post,
      data: payload.toJson(),
    );
    await localCacheService.removeById(LocalCacheService.keyAdd, payload.id!);
    return MNote.fromJson(Map<String, dynamic>.from(res.data));
  }

  @override
  Future<bool> deteteNote(int id) async {
    // save in local first
    await localCacheService.saveDelete(MNote(id: id).toJson());
    makeRequest(path: "$path/$id", method: HTTPMethod.delete);
    // delete from local if success
    await localCacheService.removeById(LocalCacheService.keyDelete, id);
    return true;
  }

  @override
  Future<List<MNote>> fetchNote() async {
    Response response = await makeRequest(path: path, method: HTTPMethod.get);
    if (response.data != null) {
      return (response.data as List<dynamic>).map((data) {
        return MNote.fromJson(data as Map<String, dynamic>);
      }).toList();
    }
    return [];
  }

  @override
  Future<MNote> updateNote(MNote payload) async {
    await localCacheService.saveUpdate(payload.toJson());
    Response res = await makeRequest(
      path: "$path/${payload.id}",
      method: HTTPMethod.put,
      data: payload.toJson(),
    );
    await localCacheService.removeById(
      LocalCacheService.keyUpdate,
      payload.id!,
    );
    return MNote.fromJson(Map<String, dynamic>.from(res.data));
  }
}
