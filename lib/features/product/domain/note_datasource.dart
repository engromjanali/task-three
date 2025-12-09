import 'package:task_three/features/product/data/model/m_note.dart';

abstract class INoteDataSource {
  Future<MNote> addNote(MNote payload);
  Future<MNote> updateNote(MNote payload);
  Future<bool> deteteNote(int id);
  Future<List<MNote>> fetchNote();
}
