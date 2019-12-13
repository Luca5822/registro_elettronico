import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/data/network/exception/server_exception.dart';
import 'package:registro_elettronico/data/repository/subjects_resposiotry_impl.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_event.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/components/event_card.dart';
import 'package:registro_elettronico/ui/feature/home/components/lesson_card.dart';
import 'package:registro_elettronico/ui/feature/home/components/subjects_grid.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/section_header.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppLocalizations trans = AppLocalizations.of(context);

    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
      ),
      appBar: AppBar(
        title: Text('Registro elettronico'),
        backgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              BlocProvider.of<LessonsBloc>(context).add(FetchLessons());
              BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
              BlocProvider.of<SubjectsBloc>(context).add(FetchSubjects());
              BlocProvider.of<GradesBloc>(context).add(FetchGrades());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {
              final lessonDao = LessonDao(Injector.appInstance.getDependency());
              lessonDao.deleteLessons();
            },
          ),
        ],
      ),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsLoading) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Loading new data...'),
              duration: Duration(seconds: 3),
            ));
          }

          if (state is LessonsError) {
            if (state.error.response.statusCode == 422) {
              final exception =
                  ServerException.fromJson(state.error.response.data);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(exception.message),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Log out',
                  onPressed: () {
                    AppNavigator.instance.navToLogin(context);
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                  },
                ),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error.error.toString()),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Log out',
                  onPressed: () {
                    AppNavigator.instance.navToLogin(context);
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                  },
                ),
              ));
            }
          }
        },
        child: RefreshIndicator(
          onRefresh: _test,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              child: RefreshIndicator(
                onRefresh: _test,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionHeader(
                      headingText: 'Last lessons',
                      onTap: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      child: Container(
                        height: 140,
                        child: _buildLessonsCards(context),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                trans.translate("notice_board"),
                                style: Theme.of(context).textTheme.headline,
                              ),
                              Text(
                                trans.translate("discover_all_notice"),
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 14),
                              )
                            ],
                          ),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child: Text(
                              trans.translate("view"),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    SectionHeader(
                      headingText: 'Next events',
                      onTap: () {},
                    ),
                    _buildAgenda(context),
                    Divider(color: Colors.grey[300]),
                    SectionHeader(
                      headingText: 'My subjects',
                      onTap: () {},
                    ),
                    _buildSubjectsGrid(context),
                    Divider(color: Colors.grey[300]),
                    SectionHeader(
                      headingText: 'Last grades',
                      onTap: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildLastGrades(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _test() async {
    await Future.delayed(Duration(seconds: 1));
  }

  StreamBuilder<List<Grade>> _buildLastGrades(BuildContext context) {
    return StreamBuilder(
      // todo: change this to date by event
      stream: BlocProvider.of<GradesBloc>(context).watchNumberOfGradesByDate(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Grade> grades = snapshot.data.toSet().toList() ?? List();

        return IgnorePointer(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: grades.length,
            itemBuilder: (BuildContext context, int index) {
              print(grades[index].notesForFamily);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GradeCard(
                  grade: grades[index],
                ),
              );
            },
          ),
        );
      },
    );
  }

  StreamBuilder<List<db.AgendaEvent>> _buildAgenda(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<AgendaBloc>(context).watchAllEvents(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<db.AgendaEvent> events =
            snapshot.data.toSet().toList() ?? List();
        return IgnorePointer(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              //final db.AgendaEvent event = events[index];

              return AgendaCardEvent(
                agendaEvent: events[index],
              );
            },
          ),
        );
      },
    );
  }

  StreamBuilder<List<Subject>> _buildSubjectsGrid(BuildContext context) {
    return StreamBuilder(
      stream:
          // todo: change to stream
          SubjectDao(Injector.appInstance.getDependency()).watchAllSubjects(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Subject> subjects = snapshot.data ?? List();
        return StreamBuilder(
          stream: BlocProvider.of<GradesBloc>(context).watchAllGrades(),
          initialData: List(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final List<dynamic> grades = snapshot.data ?? List();
            if (subjects.length == 0) {
              return Center(
                child: Text('😕 No subjects'),
              );
            }
            return SubjectsGrid(
              subjects: GlobalUtils.removeUnwantedSubject(subjects),
              grades: grades,
            );
          },
        );
      },
    );
  }

  StreamBuilder<List<Lesson>> _buildLessonsCards(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context).lessons,
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Lesson> lessons = snapshot.data ?? List();
        if (lessons.length == 0) {
          // todo: maybe a better placeholder?
          return Center(
            child: Text(
                '${AppLocalizations.of(context).translate('nothing_here')} 😶'),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (_, index) {
              final lesson = lessons[index];
              return LessonCard(
                lesson: lesson,
              );
            },
          );
        }
      },
    );
  }
}
