import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/domain/note_datasource.dart';
import 'package:task_three/features/product/domain/note_repository.dart';

class NoteRepositoryImpl extends INoteRepository {
  final INoteDataSource _iNoteDataSource;
  NoteRepositoryImpl(this._iNoteDataSource);

  @override
  Future<MNote> addNote(MNote payload) async {
    return _iNoteDataSource.addNote(payload);
  }

  @override
  Future<bool> deteteNote(int id) async {
    return _iNoteDataSource.deteteNote(id);
  }

  @override
  Future<List<MNote>> fetchNote() async {
    return _iNoteDataSource.fetchNote();
  }

  @override
  Future<MNote> updateNote(MNote payload) async {
    return _iNoteDataSource.updateNote(payload);
  }
}
