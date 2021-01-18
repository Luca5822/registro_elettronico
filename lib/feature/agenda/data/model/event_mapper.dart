import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/utils/global_utils.dart';

import 'agenda_remote_model.dart';

/// IntColumn get evtId => integer()();
/// TextColumn get evtCode => text()();
/// DateTimeColumn get begin => dateTime()();
/// DateTimeColumn get end => dateTime()();
/// BoolColumn get isFullDay => boolean()();
/// TextColumn get notes => text()();
/// TextColumn get authorName => text()();
/// TextColumn get classDesc => text()();
/// IntColumn get subjectId => integer()();
/// TextColumn get subjectDesc => text()();

class EventMapper {
  static db.AgendaEvent convertEventEntityToInsertable(
    AgendaRemoteModel event,
    Color color, {
    String title,
  }) {
    return db.AgendaEvent(
      evtId: event.evtId ?? -1,
      evtCode: event.evtCode ?? "",
      begin: DateTime.parse(event.evtDatetimeBegin) ?? DateTime.now(),
      end: DateTime.parse(event.evtDatetimeEnd) ?? DateTime.now(),
      isFullDay: event.isFullDay ?? false,
      notes: event.notes ?? "",
      authorName: event.authorName ?? "",
      classDesc: event.classDesc ?? "",
      subjectId: event.subjectId ?? 0,
      subjectDesc: event.subjectDesc ?? "",
      isLocal: false,
      labelColor: GlobalUtils.getColorCode(color) ?? Colors.green,
      title: title ?? '',
    );
  }
}