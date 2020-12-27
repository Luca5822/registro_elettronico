import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/agenda/data/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/didactics_dao.dart';
import 'package:registro_elettronico/data/db/dao/document_dao.dart';
import 'package:registro_elettronico/feature/grades/data/dao/grade_dao.dart';
import 'package:registro_elettronico/feature/lessons/data/dao/lesson_dao.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/noticeboard/data/dao/notice_dao.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/feature/subjects/data/dao/subject_dao.dart';
import 'package:registro_elettronico/feature/timetable/data/dao/timetable_dao.dart';
import 'package:registro_elettronico/feature/absences/data/model/absence_local_model.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_local_model.dart';
import 'package:registro_elettronico/data/db/table/attachment_table.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/content_local_model.dart';
import 'package:registro_elettronico/data/db/table/didactics/downloaded_file_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/folder_local_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/local/teacher_local_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/lessons/data/model/lesson_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/local_grade_local_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/note_local_model.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice_local_model.dart';
import 'package:registro_elettronico/feature/periods/data/model/period_local_model.dart';
import 'package:registro_elettronico/data/db/table/professor_table.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';
import 'package:registro_elettronico/feature/subjects/data/model/subject_local_model.dart';
import 'package:registro_elettronico/feature/timetable/data/model/timetale_local_model.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [
  Profiles,
  Lessons,
  Subjects,
  Professors,
  Grades,
  AgendaEvents,
  Absences,
  Periods,
  Notices,
  Attachments,
  Notes,
  NotesAttachments,
  DidacticsTeachers,
  DidacticsFolders,
  DidacticsContents,
  DidacticsDownloadedFiles,
  LocalGrades,
  TimetableEntries,
  Documents,
  SchoolReports,
  DownloadedDocuments,
], daos: [
  ProfileDao,
  LessonDao,
  SubjectDao,
  ProfessorDao,
  GradeDao,
  AgendaDao,
  AbsenceDao,
  PeriodDao,
  NoticeDao,
  NoteDao,
  DidacticsDao,
  TimetableDao,
  DocumentsDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          (FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite',
            logStatements: true,
          )),
        );

  @override
  int get schemaVersion => 1;

  /// Deletes all the tables from the db except the profiles, so the user is not logged out
  Future resetDbWithoutProfile() async {
    for (var table in allTables) {
      if (table.actualTableName != "profiles") {
        await delete(table).go();
      }
    }
  }

  /// This deletes [everything] from the database, the next time the user logs
  /// log in is [required]
  Future resetDb() async {
    for (var table in allTables) {
      await delete(table).go();
    }
  }
}
