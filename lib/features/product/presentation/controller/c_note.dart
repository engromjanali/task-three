import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:task_three/core/constants/default_values.dart';
import 'package:task_three/core/controllers/c_base.dart';
import 'package:task_three/core/data/local/sync_service.dart';
import 'package:task_three/core/functions/f_printer.dart';
import 'package:task_three/core/widgets/load_and_error/models/view_state_model.dart';
import 'package:task_three/features/product/data/model/m_note.dart';
import 'package:task_three/features/product/data/model/m_query.dart';
import 'package:task_three/features/product/domain/note_repository.dart';

class CNote extends CBase {
  final INoteRepository _iNoteRepository;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  CNote(this._iNoteRepository) {
    printer("new new");
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  List<MNote> noteList = [];
  final int limit = PDefaultValues.limit;
  int firstPage = 1;
  int lastPage = 1;
  bool hasMoreNext = true;
  bool get hasMorePrev => firstPage > 1;
  bool isLoadingMore = false;
  bool _isOnline = false;

  void setIsOnline(bool val) {
    _isOnline = val;
    notifyListeners();
  }

  void clearPaigenationChace() {
    hasMoreNext = true;
    isLoadingMore = false;
    lastPage = 1;
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      errorPrint('Couldn\'t check connectivity status');
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
    if (_connectionStatus.contains(ConnectivityResult.none)) {
      printer("offline");
      setIsOnline(false);
    } else {
      printer("online");
      setIsOnline(true);
      // we gat online.
      // so synce data.
      SyncService syncService = SyncService();
      await syncService.initSync();
    }
  }

  Future<void> addNote(MNote payload) async {
    try {
      isLoadingMore = true;
      update();
      MNote mNote = await _iNoteRepository.addNote(payload);
      await Future.delayed(Duration(seconds: 2));
      printer(noteList.length);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> updateNote(MNote payload) async {
    try {
      isLoadingMore = true;
      update();
      MNote mNote = await _iNoteRepository.updateNote(payload);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> deleteNote(int id) async {
    printer("deleteWhere id = $id");
    try {
      isLoadingMore = true;
      update();
      await _iNoteRepository.deteteNote(id);
      // clear from runtime storage
      noteList.removeWhere((mNote) => mNote.id == id);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<List<MNote>?> fetchNote({MQuery? payload}) async {
    try {
      if (isLoadingMore) {
        return null; //Already loading
      }
      isLoadingMore = true;
      viewState = ViewState.loading;
      update();
      await Future.delayed(Duration(seconds: 2));
      List<MNote> res = await _iNoteRepository.fetchNote();
      noteList.addAll(res);
      update();
      return res;
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      viewState = ViewState.loaded;
      update();
    }
    return null;
  }
}
